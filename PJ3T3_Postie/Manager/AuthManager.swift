//
//  AuthManager.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 1/17/24.
//

import OSLog

import FirebaseAuth
import FirebaseFirestore

//로그인하는데 사용하는 Form마다 적용하여 Form의 내용이 유효한지 검증한다.
protocol AuthenticationProtocol {
    var formIsValid: Bool { get }
}

class AuthManager: ObservableObject {
    static let shared = AuthManager()
    var userUid: String  = ""
    var provider: AuthProviderOption?
    @Published var hasAccount: Bool = true
    @Published var userSession: FirebaseAuth.User? //Firebase user object
    @Published var currentUser: PostieUser? //User Data Model
    @Published var credential: OAuthCredential?
    @Published var authDataResult: AuthDataResult?
    
    private init() {
        Task {
            checkAppLaunch()
            await fetchUser()
        }
    }
    
    func checkAppLaunch() {
        let userDefaults = UserDefaults.standard

        Logger.auth.info("UserDefault \(userDefaults.value(forKey: "appFirstTimeOpend").debugDescription)")
        //앱이 설치된 후 처음 실행 되는 것이라면 nil이다.
        if userDefaults.value(forKey: "appFirstTimeOpend") == nil {
            userDefaults.setValue(true, forKey: "appFirstTimeOpend")
            do {
                try Auth.auth().signOut()
            } catch {
                Logger.auth.error("Failed to signOut")
                self.userSession = nil
                self.currentUser = nil
            }
        } else {
            Logger.auth.info("앱 설치 후 최초 실행이 아닙니다.")
        }
    }
    
    /**
     ```
     1. Authentication에 입력받은 계정이 존재하는지 확인한다.
     2. 해당 계정의 uuid로 firestore에서 계정 정보를 불러온다.
     3. Firestore에서 받은 데이터를 model에 맞는 형태로 변환(decoding)하여 currentUser에 값을 부여한다.
     ```
     ### Usage ###
     - init될 때: Firebase에서 디바이스에 캐시 데이터로 저장해 둔 currentUser가 로그인을 한 상태인지에 대한 정보를 활용한다.
     - createUser의 가장 마지막: 계정이 제대로 생성되었는지를 확인하며 앱에서 로그인 처리를 한다.
     - signInWithSSO의 가장 마지막: 계정이 있는지 없는지 여부를 확인하여 NicknameView나 HomeView중 한 화면으로 전환된다.
     - signInWithEmail의 가장 마지막: 계정이 제대로 생성되었는지를 확인하며 앱에서 로그인 처리를 한다.
     ### Notes ###
     UI 업데이트는 꼭 메인 스레드에서 진행되어야 한다. 비동기 네트워킹은 기본적으로 메인이 아닌 다른 스레드에서 진행된다. UI 업데이트를 하는 Publish가 반드시 메인 스레드에서 수행되도록 설정하기 위해 클래스나 함수 상단에 @MainActor를 붙여주거나 DispatchQueue.main.async에서 코드를 실행해야 한다.
     */
    func fetchUser() async {
        DispatchQueue.main.async {
            //1. Authentication에 입력받은 계정이 존재하는지 확인한다.
            self.userSession = Auth.auth().currentUser
            Logger.auth.info("\(self.userSession)")
        }
        
        guard let uid = Auth.auth().currentUser?.uid else {
            Logger.auth.error("\(#function) Returned since no userSession")
            return
        }
        
        DispatchQueue.main.async {
            Logger.auth.info("\(#function) User uid updated: \(uid)")
            self.userUid = uid
        }
        
        //2. 해당 계정의 uuid로 firestore에서 계정 정보를 불러온다.
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else {
            Logger.auth.error("\(#function) Failed to fetch user data from firestore")
            return
        }
        
        DispatchQueue.main.async {
            //3. Firestore에서 받은 데이터를 User model에 맞는 형태로 변환(decoding)하여 currentUser에 값을 부여한다.
            self.currentUser = try? snapshot.data(as: PostieUser.self)
            Logger.auth.info("\(#function) Current user is \(String(describing: self.currentUser))")

            //hasAccount의 default는 ture로 로그인 과정에서 account가 있는지 확인하는 동안 ProgressView를 보여준다.
            //이 과정이 없을 경우 로그인 계정이 있음에도 NicknameView가 잠시 나타났다가 홈 뷰로 넘어가는 문제가 발생한다.
            self.hasAccount = self.currentUser != nil
        }
        
        self.getProviders()
        FirestoreManager.shared.fetchReference()
        StorageManager.shared.fetchReference()
    }
    
    func createUser(authDataResult: AuthDataResult, nickname: String) async throws {
        do {
            //입력받은 데이터를 바탕으로 User 프로퍼티 생성
            let postieUser = PostieUser(id: authDataResult.user.uid,
                                        fullName: authDataResult.user.displayName ?? "익명의 포스티",
                                        nickname: nickname,
                                        email: authDataResult.user.email ?? "No Email?!",
                                        profileImageUrl: authDataResult.user.photoURL?.absoluteString)
            
            //유저 구조체 인코딩
            let encodedUser = try Firestore.Encoder().encode(postieUser)
            
            //Firebase 업로드
            try await Firestore.firestore().collection("users").document(postieUser.id).setData(encodedUser)
            
            //회원가입을 하면 userSession이 업데이트 되며 Firestore에 데이터를 저장하는데,
            //userSession이 업데이트 됨에 따라 자동으로 Login 된 유저 뷰로 Navigate 되면, 업로드 된 Firestore의 데이터를 fetch해준다.
            await fetchUser()
        } catch {
            Logger.auth.error("DEBUG: Failed to create user with error \(error.localizedDescription)")
        }
    }
    
    //로그인 화면으로 돌아가고, back-end에서 로그아웃 되어야 한다.
    func signOut() {
        do {
            try Auth.auth().signOut() //Signs out user on backend
            self.userSession = nil //userSession의 데이터가 사라지며 ContentView에서 Login하기 전 화면을 보여주게 된다.
            self.currentUser = nil //데이터 모델을 초기화시켜 현재 유저의 데이터를 지운다.
        } catch {
            Logger.auth.error("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    func deleteAccount() async throws {
        try await self.userSession?.delete()
        guard let userUid = self.userSession?.uid else {
            Logger.auth.error("\(#function) Cannot get userUid from userSession")
            return
        }
        
        FirestoreManager.shared.deleteUserDocument(userUid: userUid)
        
        DispatchQueue.main.async {
            self.userSession = nil
            self.currentUser = nil
            self.credential = nil
        }
    }
    
    func getProviders() {
        guard let providerData = Auth.auth().currentUser?.providerData else {
            Logger.auth.error("\(#function) Failed to get provider")
            return
        }
        
        for provider in providerData {
            if let option = AuthProviderOption(rawValue: provider.providerID) {
                self.provider = option
            } else {
                //fatalError()는 앱이 종료되므로 사용하지 않기를 권장한다. fatalError, preconditionFailure와의 차이점은?
                assertionFailure("Provider option not found: \(provider.providerID)")
            }
        }
    }
    
    func authErrorCodeConverter(error: NSError) throws {
        let errorCode = AuthErrorCode.Code(rawValue: error.code)
        
        switch errorCode {
        case .userMismatch:
            throw AuthErrorCodeCase.userMismatch
        case .requiresRecentLogin:
            throw AuthErrorCodeCase.requiresRecentLogin
        case .invalidCredential:
            throw AuthErrorCodeCase.invalidCredential
        default:
            Logger.auth.error("\(#function) Failed to delete Google account AuthErrorCode: \(error)")
        }
    }
}

// MARK: Sign in SSO
extension AuthManager {
    func signInWithSSO(credential: AuthCredential) async throws -> AuthDataResult {
        let authDataResult = try await Auth.auth().signIn(with: credential)
        await fetchUser()
        
        DispatchQueue.main.async {
            self.credential = nil
        }
        
        return authDataResult
    }
    
    func signInWithGoogle() async throws -> AuthCredential {
        let helper = GoogleSignInHelper()
        let tokens = try await helper.googleHelperSingIn()
        
        if userSession != nil {
            if tokens.email != userSession?.email {
                throw AuthErrorCode(.userMismatch)
            } else {
                return GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
            }
        }
        
        return GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
    }
    
    func deleteGoogleAccount() async throws {
        do {
            let credential = try await signInWithGoogle()
            try await self.userSession?.reauthenticate(with: credential)
        } catch let error as NSError {
            if error.code == GIDSignInErrorCode.canceled.rawValue {
                throw GIDSignInErrorCode.canceled
            } else if let _ = AuthErrorCode.Code(rawValue: error.code) {
                try authErrorCodeConverter(error: error)
            } else {
                Logger.auth.error("\(#function) Failed to delete Google account: \(error)")
            }
        }
    }
    
    func signInwithApple(user: AppleUser) {
        self.credential = OAuthProvider.appleCredential(withIDToken: user.token,
                                                        rawNonce: user.nonce,
                                                        fullName: user.fullName)
    }
    
    func reAuthAppleAccount(user: AppleUser) async throws {
        let credential = OAuthProvider.appleCredential(withIDToken: user.token,
                                                       rawNonce: user.nonce,
                                                       fullName: user.fullName)
        let authDataResult = try await signInWithSSO(credential: credential)
        
        DispatchQueue.main.async {
            self.authDataResult = authDataResult
        }
    }
    
    func deleteAppleAccount(credential: OAuthCredential, authCodeString: String) async throws {
        do {
            try await self.userSession?.reauthenticate(with: credential)
            try await Auth.auth().revokeToken(withAuthorizationCode: authCodeString)
            try await self.deleteAccount()
        } catch let error as NSError {
            if let _ = AuthErrorCode.Code(rawValue: error.code) {
                try authErrorCodeConverter(error: error)
            } else {
                Logger.auth.error("\(#function) Failed to delete Apple account: \(error)")
            }
        }
    }
    
    func deleteAppleAccount(user: AppleUser, authCodeString: String) async {
        let credential = OAuthProvider.appleCredential(withIDToken: user.token,
                                                       rawNonce: user.nonce,
                                                       fullName: user.fullName)
        DispatchQueue.main.async {
            self.credential = credential
        }
        
        do {
            try await self.userSession?.reauthenticate(with: credential)
            try await Auth.auth().revokeToken(withAuthorizationCode: authCodeString)
            try await self.deleteAccount()
        } catch {
            Logger.auth.error("\(#function) Failed to delete Apple account: \(error)")
        }
    }
}

// MARK: Sign in Email
extension AuthManager {
    func signInWithEmail(withEamil email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            
            //fetchUser가 uid로 firebase에서 데이터를 찾기 위해서는 반드시 signIn이 완료 된 다음 fetchUser 함수를 호출해야 한다.
            await fetchUser()
        } catch {
            Logger.auth.error("DEBUG: Failed to log in with error \(error.localizedDescription)")
        }
    }

    func createEmailUser(withEamil email: String, password: String, fullName: String, nickname: String) async throws {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        
        changeRequest?.displayName = fullName
        
        do {
            try await changeRequest?.commitChanges()
        } catch {
            Logger.auth.error("\(#function) Unable to update the user's displayname: \(error.localizedDescription)")
        }
        
        try await createUser(authDataResult: authDataResult, nickname: nickname)
    }
    
    func deleteEmailUser(email: String, password: String) async {
        do {
            let credential = EmailAuthProvider.credential(withEmail: email, password: password)
            
            try await self.userSession?.reauthenticate(with: credential)
            try await self.deleteAccount()
        } catch {
            Logger.auth.error("\(#function) Failed to reauth: \(error)")
        }
        
    }
}
