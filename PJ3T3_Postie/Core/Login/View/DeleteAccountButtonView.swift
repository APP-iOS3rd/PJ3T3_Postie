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
                        authManager.deleteAccount()
                        showLoading = true
                    } catch {
                        print(#function, "Failed to delete Google account: \(error)")
                        showLoading = false
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
}

#Preview {
    DeleteAccountButtonView(showLoading: .constant(false))
}
