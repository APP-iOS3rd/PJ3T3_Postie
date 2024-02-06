//
//  GoogleSignInHelper.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 2/1/24.
//

import GoogleSignIn

final class GoogleSignInHelper {
    @MainActor
    func topViewController(controller: UIViewController? = nil) -> UIViewController? {
        let controller = controller ?? UIApplication.shared.keyWindow?.rootViewController
        
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
    
    @MainActor //TopVC를 찾고, 뷰 위에 Modal을 띄우는 작업은 메인 스레드에서 수행되어야 한다.
    func googleHelperSingIn() async throws -> GoogleUser {
        guard let topVC = topViewController() else {
            throw URLError(.cannotFindHost)
        }
        
        //구글 로그인 Modal이 뷰에 표시되는 동안 App은 대기상태가 된다.
        let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
        
        guard let idToken: String = gidSignInResult.user.idToken?.tokenString else {
            throw URLError(.badServerResponse)
        }
        
        let accessToken: String = gidSignInResult.user.accessToken.tokenString
        let name = gidSignInResult.user.profile?.name
        let email = gidSignInResult.user.profile?.email
        var imageURL: String? = nil
        if gidSignInResult.user.profile?.hasImage != nil {
            imageURL = gidSignInResult.user.profile?.imageURL(withDimension: 100)?.absoluteString
        }
        
        let tokens = GoogleUser(idToken: idToken, accessToken: accessToken, name: name, email: email, imageURL: imageURL)
        
        return tokens
    }
}
