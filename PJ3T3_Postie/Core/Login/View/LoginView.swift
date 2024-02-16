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
                
                ToFromLabelView(isThemeGroupButton: $isThemeGroupButton)
                    .padding()
                
                VStack {
                    Text("Postie")
                        .font(.custom("SourceSerifPro-Black", size: 70))
                        .foregroundStyle(postieColors.tintColor)
                        .padding(.bottom, 36)
                    
                    Image("postySendingLineColor")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 152)
                    
                    Text("내 손안의 편지 보관함\n언제 어디서나")
                        .foregroundStyle(postieColors.dividerColor)
                        .padding(.bottom, 48)
                        .multilineTextAlignment(.center)

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
                    .padding(.bottom, 19)
                    
                    //Email sign in: 테스트용 이메일을 사용하기 위한 것으로 배포시 삭제 예정입니다.
                    NavigationLink {
                        EmailLoginView()
                    } label: {
                        HStack {
                            Text("테스트용 이메일 계정으로 ")
                                .foregroundColor(postieColors.tabBarTintColor)
                            
                            Text("로그인 하기")
                                .foregroundColor(postieColors.tintColor)
                        }
                    }
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
