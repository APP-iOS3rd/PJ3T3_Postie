//
//  LoginView.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 1/17/24.
//

import SwiftUI
import GoogleSignInSwift

struct LoginView: View {
    @ObservedObject var authManager = AuthManager.shared
    
    var body: some View {
        NavigationStack {
            ZStack {
                Rectangle()
                    .foregroundStyle(.postieBeige)
                    .ignoresSafeArea()
                
                VStack {
                    Image(systemName: "envelope")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120)
                        .padding(.vertical, 36)

                    //Email sign in: 테스트용 이메일을 사용하기 위한 것으로 배포시 삭제 예정입니다.
                    NavigationLink {
                        EmailLoginView()
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

                    //Google sign in Button
                    GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .light, style: .wide, state: .normal)) {
                        Task {
                            do {
                                let credential = try await authManager.signInWithGoogle()
                                authManager.authDataResult = try await authManager.signInWithSSO(credential: credential)
                            } catch {
                                print(error)
                            }
                        }
                    }
                }
                .padding(.horizontal, 32)
            }
        }
    }
}

#Preview {
    LoginView()
}
