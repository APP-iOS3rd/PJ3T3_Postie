//
//  DeleteAccountButtonView.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 2/16/24.
//

import SwiftUI

struct DeleteAccountButtonView: View {
    @ObservedObject var authManager = AuthManager.shared
    @Binding var showLoading: Bool
    @Binding var showAlert: Bool
    @Binding var alertBody: String
    
    var body: some View {
        Button("계정 삭제", role: .destructive) {
            switch authManager.provider {
            case .email:
                Task {
                    print("Cannot delete Email account")
                    authManager.signOut()
                }
            case .google:
                print("Delete Google account")
                Task {
                    do {
                        try await authManager.deleteGoogleAccount()
                        showLoading = true
                        try await authManager.deleteAccount()
                    } catch {
                        googleLoginFailure(error: error)
                        showLoading = false
                        showAlert = true
                    }
                }
            case .apple:
                print("Delete Apple account")
                AppleSignInHelper.shared.reAuthCurrentAppleUser()
                showLoading = true
            default:
                print("Delete account")
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
            alertBody = "현재 로그인중인 사용자가 아니에요. 계정을 다시 확인 해 주세요."
        case GIDSignInErrorCode.canceled:
            alertBody = "재인증이 취소되었습니다. 회원 탈퇴를 위해서는 계정 재인증을 위한 로그인이 필요합니다."
        case AuthErrorCodeCase.requiresRecentLogin:
            alertBody = "재인증이 취소되었습니다. 회원 탈퇴를 위해서는 계정 재인증을 위한 로그인이 필요합니다."
        default:
            alertBody = "알 수 없는 오류가 발생하였습니다. 회원 탈퇴를 위해서는 관리자에게 문의 해 주세요.\nteam.postie@google.com"
            print(#function, "Failed to delete Google account: \(error)")
        }
    }
}

#Preview {
    DeleteAccountButtonView(showLoading: .constant(false), showAlert: .constant(false), alertBody: .constant("프리뷰"))
}
