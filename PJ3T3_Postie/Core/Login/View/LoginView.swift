//
//  LoginView.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 1/17/24.
//

import SwiftUI
import AuthenticationServices

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
                                .font(.system(size: 20, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(height: 54)
                        .frame(maxWidth: .infinity)
                    }
                    .background(.postieOrange)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .shadow(radius: 3, x: 3, y: 3)
                    .padding(.bottom, 10)

                    //Google sign in Button
                    Button {
                        Task {
                            do {
                                let credential = try await authManager.signInWithGoogle()
                                authManager.authDataResult = try await authManager.signInWithSSO(credential: credential)
                            } catch {
                                print(error)
                            }
                        }
                    } label: {
                        Image("GoogleSignIn")
                            .resizable()
                            .scaledToFit()
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                .stroke(Color(.black), lineWidth: 0.5))
                            .shadow(radius: 3, x: 3, y: 3)
                    }
                    .padding(.bottom, 10)
                    
                    SignInWithAppleButton { request in
                        
                    } onCompletion: { result in
                        
                    }
                    .frame(height: 54)
                    .signInWithAppleButtonStyle(.black)
                    .shadow(radius: 3, x: 3, y: 3)
                }
                .padding(.horizontal, 32)
            }
        }
    }
}

#Preview {
    LoginView()
}
