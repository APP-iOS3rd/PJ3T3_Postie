//
//  AppleSignInHelper.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 2/5/24.
//

import AuthenticationServices
import CryptoKit

final class AppleSignInHelper: NSObject, ObservableObject {
    static let shared = AppleSignInHelper()
    private var nonce = ""
    var cryptoUtils: CryptoUtils?
    var window: UIWindow?
    
    private override init() { }
    
    func signInWithAppleRequest(_ request: ASAuthorizationOpenIDRequest) {
        self.cryptoUtils = CryptoUtils()
        
        guard let cryptoUtils = cryptoUtils else {
            print(#function, "Failed to ")
            return
        }
        
        nonce = cryptoUtils.randomNonceString
        request.requestedScopes = [.fullName, .email]
        request.nonce = cryptoUtils.nonce
    }
    
    func signInWithAppleCompletion(_ result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let user):
            guard let appleIDCredential = user.credential as? ASAuthorizationAppleIDCredential else {
                print(#function, "Unable to retrieve AppleIDCredential")
                return
            }
            
            guard let appleIDToken = appleIDCredential.identityToken else {
                print(#function, "Unable to fetch identity token")
                return
            }
            
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print(#function, "Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            
            guard let fullName = appleIDCredential.fullName else {
                print(#function, "Unalbe to get PersonNameComponents: \(appleIDToken.debugDescription)")
                return
            }
            
            let appleUser = AppleUser(token: idTokenString, nonce: nonce, fullName: fullName)
            
            AuthManager.shared.signInwithApple(user: appleUser)
        case .failure(let failure):
            print(failure.localizedDescription)
        }
    }
    
    func deleteCurrentAppleUser() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        
        self.cryptoUtils = CryptoUtils()
        
        guard let cryptoUtils = cryptoUtils else {
            print(#function, "Failed to ")
            return
        }
        
        nonce = cryptoUtils.randomNonceString
        request.requestedScopes = [.fullName, .email]
        request.nonce = cryptoUtils.nonce
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        
        authorizationController.delegate = self
        
        if let window = window {
            let provider = ContextProvider(window: window)
            authorizationController.presentationContextProvider = provider
        }
        
        authorizationController.performRequests()
    }
}

extension AppleSignInHelper: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            print(#function, "Unable to retrieve AppleIDCredential")
            return
        }
        
        guard let appleAuthCode = appleIDCredential.authorizationCode else {
            print(#function, "Unable to fetch authorization code")
            return
        }
        
        guard let authCodeString = String(data: appleAuthCode, encoding: .utf8) else {
            print(#function, "Unable to serialize auth code string from data: \(appleAuthCode.debugDescription)")
            return
        }
        
        guard let appleIDToken = appleIDCredential.identityToken else {
            print(#function, "Unable to fetch identity token")
            return
        }
        
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            print(#function, "Unable to serialize token string from data: \(appleIDToken.debugDescription)")
            return
        }
        
        guard let fullName = appleIDCredential.fullName else {
            print(#function, "Unalbe to get PersonNameComponents: \(appleIDToken.debugDescription)")
            return
        }
        
        let appleUser = AppleUser(token: idTokenString, nonce: nonce, fullName: fullName)
        
        //회원 탈퇴를 위해서는 재인증이 필요하다. 재인증을 위한 credential을 생성 하기 위해서는 로그인을 다시 해야 한다.
        AuthManager.shared.signInwithApple(user: appleUser)
        
        Task {
            await AuthManager.shared.deleteAppleAccount(authCodeString: authCodeString)
        }
    }
}

final class ContextProvider: NSObject, ASAuthorizationControllerPresentationContextProviding {
    private var window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        window
    }
}
