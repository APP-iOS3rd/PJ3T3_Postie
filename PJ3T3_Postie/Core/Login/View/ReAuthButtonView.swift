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
    @Binding var showFailureAlert: Bool
    @Binding var showSuccessAlert: Bool
    @Binding var alertBody: String
    
    var body: some View {
        Button("계정 재인증") {
            switch authManager.provider {
            case .google:
                print("Re-Auth Google account")
                Task {
                    do {
                        let credential = try await authManager.signInWithGoogle()
                        authManager.authDataResult = try await authManager.signInWithSSO(credential: credential)
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
                        showFailureAlert = true
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
        .customOnChange(authManager.authDataResult) { newValue in
            if authManager.authDataResult == nil {
                print(#function, "on change authDataResult nil")
                showSuccessAlert = false
            } else {
                print(#function, "on change authDataResult not nil")
                showSuccessAlert = true
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
    ReAuthButtonView(showFailureAlert: .constant(false), showSuccessAlert: .constant(false), alertBody: .constant("프리뷰"))
}
