//
//  DeleteAccountButtonView.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 2/16/24.
//

import OSLog
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
                    Logger.auth.info("Cannot delete Email account")
                    authManager.signOut()
                }
            case .google:
                Logger.auth.info("Delete Google account")
                Task {
                    do {
                        try await authManager.deleteGoogleAccount()
                        showLoading = true
                        try await authManager.deleteAccount()
                    } catch {
                        loginFailure(error: error)
                        showLoading = false
                        showAlert = true
                    }
                }
            case .apple:
                Logger.auth.info("Delete Apple account")
                AppleSignInHelper.shared.reAuthCurrentAppleUser()
            default:
                Logger.auth.info("Delete account")
                //alert 창 구현
            }
        }
        .customOnChange(authManager.credential) { newValue in
            if authManager.credential == nil {
                Logger.auth.info("\(#function) Canceled to delete account")
                showLoading = false
            } else {
                showLoading = true
            }
        }
    }
    
    func loginFailure(error: Error) {
        switch error {
        case AuthErrorCodeCase.userMismatch:
            alertBody = "현재 로그인중인 사용자가 아니에요. 계정을 다시 확인해 주세요."
        case GIDSignInErrorCode.canceled:
            alertBody = "재인증이 취소되었습니다. 회원 탈퇴를 위해서는 계정 재인증을 위한 로그인이 필요합니다."
        case AuthErrorCodeCase.requiresRecentLogin:
            alertBody = "재인증이 취소되었습니다. 회원 탈퇴를 위해서는 계정 재인증을 위한 로그인이 필요합니다."
        case AuthErrorCodeCase.invalidCredential:
            alertBody = "재인증에 실패하였습니다. 다시 시도해 주세요."
        default:
            alertBody = "알 수 없는 오류가 발생하였습니다. 지속적으로 오류가 발생한다면 관리자에게 문의해 주세요.\nteam.postie@google.com"
            Logger.auth.info("\(#function) Failed to delete Google account: \(error)")
        }
    }
}

#Preview {
    DeleteAccountButtonView(showLoading: .constant(false), showAlert: .constant(false), alertBody: .constant("프리뷰"))
}
