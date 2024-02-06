//
//  AppleSignInHelper.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 2/5/24.
//

import AuthenticationServices
import CryptoKit
import SwiftUI

import FirebaseAuth

struct AppleUser {
    let token: String
    let nonce: String
    let fullName: PersonNameComponents
}

final class AppleSignInHelper: NSObject, ObservableObject {
    static let shared = AppleSignInHelper()
    private var currentNonce: String?
    private var completionHandler: ((Result<AppleUser, Error>) -> Void)? = nil
    @Published var didSignInWithApple: Bool = false
    @Published var nonce = ""
    @Published var credential: OAuthCredential?
    
    private override init() { }
    
    func signInWithAppleRequest(_ request: ASAuthorizationOpenIDRequest) {
        nonce = randomNonceString()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
    }
    
    func signInWithAppleCompletion(_ result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let user):
            guard let appleIDCredential = user.credential as? ASAuthorizationAppleIDCredential else {
                print("Credential 23")
                return
            }
            
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Error with token 27")
                return
            }
            
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Error with tokenstring 31")
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            
            guard let fullName = appleIDCredential.fullName else {
                print("Unalbe to get PersonNameComponents: \(appleIDToken.debugDescription)")
                completionHandler?(.failure(URLError(.badServerResponse)))
                return
            }
            
            let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                           rawNonce: nonce,
                                                           fullName: fullName)
        case .failure(let failure):
            print(failure.localizedDescription)
        }
    }
    
    @MainActor
    func startSignInWithAppleFlow(completion: @escaping (Result<AppleUser, Error>) -> Void) {
        guard let topVC = GoogleSignInHelper.shared.topViewController() else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        let nonce = randomNonceString()
        currentNonce = nonce
        completionHandler = completion
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = topVC
        authorizationController.performRequests()
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }
        
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        let nonce = randomBytes.map { byte in
            // Pick a random character from the set, wrapping around if needed.
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}

extension AppleSignInHelper: ASAuthorizationControllerDelegate {
    func authorizationController2(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
                completionHandler?(.failure(URLError(.badServerResponse)))
            }
            
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                completionHandler?(.failure(URLError(.badServerResponse)))
                return
            }
            
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                completionHandler?(.failure(URLError(.badServerResponse)))
                return
            }
            
            guard let fullName = appleIDCredential.fullName else {
                print("Unalbe to get PersonNameComponents: \(appleIDToken.debugDescription)")
                completionHandler?(.failure(URLError(.badServerResponse)))
                return
            }
            
            let result = AppleUser(token: idTokenString, nonce: nonce, fullName: fullName)
            completionHandler?(.success(result))
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
                completionHandler?(.failure(URLError(.badServerResponse)))
            }
            
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                completionHandler?(.failure(URLError(.badServerResponse)))
                return
            }
            
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                completionHandler?(.failure(URLError(.badServerResponse)))
                return
            }
            
            guard let fullName = appleIDCredential.fullName else {
                print("Unalbe to get PersonNameComponents: \(appleIDToken.debugDescription)")
                completionHandler?(.failure(URLError(.badServerResponse)))
                return
            }
            
            let result = AppleUser(token: idTokenString, nonce: nonce, fullName: fullName)
            completionHandler?(.success(result))
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
}

extension UIViewController: ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

//Apple로그인을 Firebase를 통해 사용하기 위해서는 UIKit을 활용해야 한다.
struct SignInWithAppleButtonViewRepresentable: UIViewRepresentable {
    let type: ASAuthorizationAppleIDButton.ButtonType
    let style: ASAuthorizationAppleIDButton.Style
    
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        return ASAuthorizationAppleIDButton(authorizationButtonType: type, authorizationButtonStyle: style)
    }
    
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {
        
    }
}
