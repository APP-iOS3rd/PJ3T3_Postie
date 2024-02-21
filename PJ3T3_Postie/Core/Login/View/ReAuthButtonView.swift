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
    @Binding var nickname: String
    
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
                    } catch {
                        print(#function, "Failed to re-auth Google account: \(error)")
                        showLoading = false
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
}

#Preview {
    ReAuthButtonView(showLoading: .constant(false), nickname: .constant("포스티"))
}
