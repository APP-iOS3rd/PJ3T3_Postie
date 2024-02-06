//
//  NicknameView.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 2/2/24.
//

import SwiftUI

struct NicknameView: View {
    @ObservedObject var authManager = AuthManager.shared
    @State var nickname: String = ""
    
    var body: some View {
        ZStack {
            Color(.postieBeige)
                .ignoresSafeArea()
            
            VStack {
                LoginInputView(title: "Nickname",
                               placeholder: "Enter your nickname",
                               text: $nickname)
                
                Button {
                    Task {
                        if let authDataResult = authManager.authDataResult {
                            try await authManager.createUser(authDataResult: authDataResult, nickname: nickname)
                        }
                    }
                } label: {
                    HStack() {
                        Image(systemName: "at")
                            .padding(.horizontal, 10)
                        
                        Text("Sign in with Email")
                            .font(.system(size: 14, weight: .semibold))
                        
                        Spacer()
                    }
                    .foregroundColor(.white)
                    .frame(height: 42)
                    .frame(maxWidth: .infinity)
                }
                .background(.postieOrange)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(radius: 3, x: 3, y: 3)
                .padding(.bottom, 10)
            }
            .padding(.horizontal, 32)
        }
    }
}

#Preview {
    NicknameView()
}
