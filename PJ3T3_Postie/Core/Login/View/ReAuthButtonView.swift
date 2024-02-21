//
//  ReAuthButtonView.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 2/20/24.
//

import SwiftUI
import AuthenticationServices

struct ReAuthButtonView: View {
    @ObservedObject var authManager = AuthManager.shared
    @Binding var showLoading: Bool
    @Binding var showAlert: Bool
    @Binding var alertBody: String
    
    var body: some View {
        Button("계정 재인증") {
            switch authManager.provider {
            case .google:
                print("Re-Auth Google account")
                Task {
                    do {
                        let credential = try await authManager.signInWithGoogle()
                        showLoading = true
                        authManager.authDataResult = try await authManager.signInWithSSO(credential: credential)
                        showLoading = false
                    } catch let error as NSError {
                        if error.code == GIDSignInErrorCode.canceled.rawValue {
                            alertBody = "재인증이 취소되었습니다. 계정 생성을 위해서는 재인증을 해 주세요."
                        } else {
                            do {
                                try authManager.authErrorCodeConverter(error: error)
                            } catch {
                                googleLoginFailure(error: error)
                            }
                        }
                        showLoading = false
                        showAlert = true
                    }
                }
            case .apple:
                print("Re-Auth Apple account")
                AppleSignInHelper.shared.isReAuth = true
                AppleSignInHelper.shared.reAuthCurrentAppleUser()
            default:
                print("Cannot re-auth account")
                //alert 창 구현
            }
        }
        .customOnChange(authManager.credential) { newValue in
            if authManager.credential == nil {
                print(#function, "Canceled to delete account")
                showLoading = false
            } else {
                showLoading = true
            }
        }
    }
    
    func googleLoginFailure(error: Error) {
        switch error {
        case AuthErrorCodeCase.userMismatch:
            print("FIR")
            alertBody = "현재 로그인중인 사용자가 아니에요. 계정을 다시 확인 해 주세요."
        case AuthErrorCodeCase.requiresRecentLogin:
            print("FIR")
            alertBody = "재인증이 취소되었습니다. 계정 생성을 위해서는 재인증을 해 주세요."
        default:
            print("FIR")
            alertBody = "알 수 없는 오류가 발생하였습니다. 계정 생성을 위해서는 관리자에게 문의 해 주세요.\nteam.postie@google.com"
            print(#function, "Failed to re-auth Google account: \(error)")
        }
    }
}

#Preview {
    ReAuthButtonView(showLoading: .constant(false), showAlert: .constant(false), alertBody: .constant("프리뷰"))
}
