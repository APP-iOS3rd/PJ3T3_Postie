//
//  AuthViewModel.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 1/17/24.
//

import FirebaseAuth
import FirebaseFirestore

//로그인하는데 사용하는 Form마다 적용하여 Form의 내용이 유효한지 검증한다.
protocol AuthenticationProtocol {
    var formIsValid: Bool { get }
}

class AuthManager: ObservableObject {
    static let shared = AuthManager()
    var userUid: String  = ""
    @Published var userSession: FirebaseAuth.User? //Firebase user object
    @Published var currentUser: User? //User Data Model
    
    private init() {
        //viewModel이 init될 때 이미 존재하는 user가 있는지 확인한다.
        //이 기능은 Firebase에서 제공하는 기능으로 currentUser가 로그인을 했는지(한 상태인지)에 대한 정보를 디바이스에 캐시 데이터로 저장해 둔다.
        self.userSession = Auth.auth().currentUser
        //로그인된 유저가 있는지 확인해서 firebase에서 제공하는 userUid를 가지고온다.
        if let userUid = Auth.auth().currentUser?.uid {
            self.userUid = userUid
        }
        
        Task {
            await fetchUser()
        }
    }

    func signIn(withEamil email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            
            DispatchQueue.main.async {
                self.userSession = result.user
            }
            
            //fetchUser가 uid로 firebase에서 데이터를 찾기 위해서는 반드시 signIn이 완료 된 다음 fetchUser 함수를 호출해야 한다.
            await fetchUser()
        } catch {
            print("DEBUG: Failed to log in with error \(error.localizedDescription)")
        }
    }

    func createUser(withEamil email: String, password: String, fullName: String) async throws {
        do {
            //1. Try to create user -> await its result -> store it to the property
            let result = try await Auth.auth().createUser(withEmail: email, password: password)

            //2. Once success, set userSession property
            DispatchQueue.main.async {
                self.userSession = result.user //result에서 user값을 받아와 userSession에 넣어줌
            }

            //3. Create our User object
            //firebase의 user는 firebase에서 새로운 user를 생성하고 uid 를 제공해준다.
            //기타 사용자에게 얻고자 하는 데이터(예: 핸드폰 번호, 생일 등)가 있다면 User Model에 구성을 추가하고 input을 받아야 한다.
            let user = User(id: result.user.uid, fullName: fullName, email: email)

            //4. Encode the object throught the codable protocol
            let encodedUser = try Firestore.Encoder().encode(user)

            //5. Upload data to Firestore
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            
            //회원가입을 하면 userSession이 업데이트 되며 Firestore에 데이터를 저장하는데,
            //userSession이 업데이트 됨에 따라 자동으로 Login 된 유저 뷰로 Navigate 되면, 업로드 된 Firestore의 데이터를 fetch해준다.
            await fetchUser()
        } catch {
            //if anything goes wrong:
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
        }
    }

    //로그인 화면으로 돌아가고, back-end에서 로그아웃 되어야 한다.
    func signOut() {
        do {
            try Auth.auth().signOut() //Signs out user on backend
            self.userSession = nil //userSession의 데이터가 사라지며 ContentView에서 Login하기 전 화면을 보여주게 된다.
            self.currentUser = nil //데이터 모델을 초기화시켜 현재 유저의 데이터를 지운다.
        } catch {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }

    func deleteAccount() {

    }

    func fetchUser() async {
        //현재 로그인중인 유저가 있다면 fetch가 진행된다. 로그인 유저가 없다면 해당 guard문을 통과하지 못하고 return된다.
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        
        //UI 업데이트는 꼭 메인 스레드에서 진행되어야 하는데
        //비동기 네트워킹은 기본적으로 메인이 아닌 다른 스레드에서 진행되므로 UI 업데이트를 하는 Publish가 반드시 메인 스레드에서 수행되도록 설정하기 위해
        //클래스 상단에 @MainActor를 선언해 주거나 아래와 같이 DispatchQueue.main.async 에서 코드를 실행해야 한다.
        DispatchQueue.main.async {
            //Firestore에서 받은 데이터를 User model에 맞는 형태로 변환하여 currentUser에 값을 부여한다.
            self.currentUser = try? snapshot.data(as: User.self)
            print("DEBUG: Current user is \(String(describing: self.currentUser))")
        }
        
        if let userUid = Auth.auth().currentUser?.uid {
            self.userUid = userUid
        }
    }
}
