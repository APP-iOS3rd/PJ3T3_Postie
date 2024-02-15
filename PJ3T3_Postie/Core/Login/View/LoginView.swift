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
    @ObservedObject var appleSignInHelper = AppleSignInHelper.shared
    @AppStorage("isThemeGroupButton") private var isThemeGroupButton: Int = 0
    
    var body: some View {
        let postieColors = ThemeManager.themeColors[isThemeGroupButton]
        
        NavigationStack {
            ZStack {
                postieColors.backGroundColor
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
                        .foregroundColor(postieColors.receivedLetterColor)
                        .frame(height: 54)
                        .frame(maxWidth: .infinity)
                    }
                    .background(postieColors.tintColor)
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
                        ZStack {
                            //Apple 로그인 버튼과 구글 로그인 버튼의 cornerRadius 일치를 위한 배경색
                            //stroke를 이미지 아래에 그리면 이미지가 stoke 라인을 조금 가려서 stoke만 이미지에 overlay함
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundStyle(.white)
                                .frame(height: 54)
                                .shadow(radius: 3, x: 3, y: 3)
                            
                            Image("GoogleSignIn")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 54)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color(.black), lineWidth: 0.5)
                                }
                        }
                    }
                    .padding(.bottom, 10)
                    
                    SignInWithAppleButton { request in
                        appleSignInHelper.signInWithAppleRequest(request)
                    } onCompletion: { result in
                        Task {
                            do {
                                appleSignInHelper.signInWithAppleCompletion(result)
                                guard let credential = authManager.credential else {
                                    print("Unable to fetch credential")
                                    return
                                }
                                authManager.authDataResult = try await AuthManager.shared.signInWithSSO(credential: credential)
                            } catch {
                                print(error)
                            }
                        }
                    }
                    .frame(height: 54)
                    .signInWithAppleButtonStyle(isThemeGroupButton == 4 ? .white : .black)
                    .shadow(radius: 3, x: 3, y: 3)
                    .padding(.bottom, 10)
                }
                .padding(.horizontal, 32)
            }
        }
    }
}

#Preview {
    LoginView()
}
