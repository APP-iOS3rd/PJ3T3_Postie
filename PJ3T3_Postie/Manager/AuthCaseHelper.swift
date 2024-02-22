//
//  AuthCaseHelper.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 2/14/24.
//

import Foundation

enum AuthProviderOption: String {
    case email = "password"
    case google = "google.com"
    case apple = "apple.com"
}

enum GIDSignInErrorCode: NSInteger, Error {
    case unknown = -1 //Indicates an unknown error has occurred.
    case keychain = -2 //Indicates a problem reading or writing to the application keychain.
    case hasNoAuthInKeychain = -4 //Indicates there are no valid auth tokens in the keychain.
    case canceled = -5 //Indicates the user canceled the sign in request.
    case EMM = -6 //Indicates an Enterprise Mobility Management related error has occurred.
    case scopesAlreadyGranted = -8 //Indicates the requested scopes have already been granted to the currentUser.
    case mismatchWithCurrentUser = -9 //Indicates there is an operation on a previous user.
}

enum AuthErrorCodeCase: Error {
    case userMismatch //로그인 한 유저와 탈퇴 인증 한 유저가 다를 경우
    case requiresRecentLogin //재인증 과정 중 취소 한 경우
}
