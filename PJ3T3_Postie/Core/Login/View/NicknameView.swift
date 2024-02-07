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
    @State var isTappable: Bool = false
    @State var isTapped: Bool = false
    
    var body: some View {
        ZStack {
            Color(.postieBeige)
                .ignoresSafeArea()
            
            VStack {
                LoginInputView(title: "Nickname",
                               placeholder: "Enter your nickname",
                               text: $nickname)
                
                Button {
                    isTappable = false
                    isTapped = true
                    Task {
                        if let authDataResult = authManager.authDataResult {
                            try await authManager.createUser(authDataResult: authDataResult, nickname: nickname)
                        }
                    }
                } label: {
                    HStack() {
                        if isTapped {
                            ProgressView()
                        } else {
                            Image(systemName: "envelope")
                                .padding(.horizontal, 10)
                            
                            Text("Submit & Sign up")
                                .font(.system(size: 20, weight: .semibold))
                        }
                    }
                    .foregroundColor(.white)
                    .frame(height: 54)
                    .frame(maxWidth: .infinity)
                }
                .background(isTappable ? .postieOrange : .postieGray)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(radius: 3, x: 3, y: 3)
                .padding(.bottom, 10)
                .disabled(!isTappable)
                .onChange(of: nickname) { newValue in
                    if !newValue.isEmpty {
                        isTappable = true
                    } else {
                        isTappable = false
                    }
                }
            }
            .padding(.horizontal, 32)
            
            VStack {
                Spacer()
                
                Button {
                    authManager.signOut()
                } label: {
                    Text("Back to Login Selection")
                }
            }
        }
    }
}

#Preview {
    NicknameView()
}
