//
//  LoginView.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 1/17/24.
//

import SwiftUI
import AuthenticationServices
import OSLog

import GoogleSignInSwift

struct LoginView: View {
    @ObservedObject var authManager = AuthManager.shared
    @ObservedObject var appleSignInHelper = AppleSignInHelper.shared
    @AppStorage("isThemeGroupButton") private var isThemeGroupButton: Int = 0
    @State private var isLoginProcessing = false
    @State private var alertBody = ""
    @State private var showAlert = false
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    postieColors.backGroundColor
                        .ignoresSafeArea()
                    
                    ToFromLabelView()
                        .padding()
                    
                    VStack {
                        Text("Postie")
                            .font(.custom("SourceSerifPro-Black", size: 70))
                            .foregroundStyle(postieColors.tintColor)
                            .padding(.bottom, geometry.size.height > 730 ? 36 : 1)
                        
                        Image("postySendingLineColor")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 152)
                        
                        Text("손으로 쓴 감동 \n 내 손안의 편지 보관함")
                            .foregroundStyle(postieColors.dividerColor)
                            .padding(.bottom, geometry.size.height > 700 ? 48 : 28)
                            .multilineTextAlignment(.center)
                        
                        //Google sign in Button
                        Button {
                            Task {
                                do {
                                    let credential = try await authManager.signInWithGoogle()
                                    isLoginProcessing = true
                                    authManager.authDataResult = try await authManager.signInWithSSO(credential: credential)
                                } catch {
                                    isLoginProcessing = false
                                    loginFailure(error: error)
                                }
                            }
                        } label: {
                            ZStack {
                                //Apple 로그인 버튼과 구글 로그인 버튼의 cornerRadius 일치를 위한 배경색
                                //stroke를 이미지 아래에 그리면 이미지가 stoke 라인을 조금 가려서 stoke만 이미지에 overlay함
                                RoundedRectangle(cornerRadius: 5)
                                    .foregroundStyle(.white)
                                    .shadow(radius: 3, x: 3, y: 3)
                                
                                if isLoginProcessing {
                                    ProgressView()
                                } else {
                                    Image("GoogleSignIn")
                                        .resizable()
                                        .scaledToFit()
                                }
                                
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color(.black), lineWidth: 0.5)
                                    .foregroundStyle(.clear)
                            }
                            .frame(height: geometry.size.height > 700 ? 54 : 44)
                        }
                        .disabled(isLoginProcessing)
                        .padding(.bottom, 10)
                        .alert("로그인 오류", isPresented: $showAlert) {
                            Button { } label: {
                                Text("확인")
                            }
                        } message: {
                            Text(alertBody)
                        }
                        
                        SignInWithAppleButton { request in
                            appleSignInHelper.signInWithAppleRequest(request)
                        } onCompletion: { result in
                            Task {
                                do {
                                    appleSignInHelper.signInWithAppleCompletion(result)
                                    guard let credential = authManager.credential else {
                                        Logger.auth.error("Unable to fetch credential")
                                        return
                                    }
                                    authManager.authDataResult = try await AuthManager.shared.signInWithSSO(credential: credential)
                                } catch {
                                    isLoginProcessing = false
                                    loginFailure(error: error)
                                }
                            }
                        }
                        .frame(height: geometry.size.height > 700 ? 54 : 44)
                        .signInWithAppleButtonStyle(isThemeGroupButton == 4 ? .white : .black)
                        .shadow(radius: 3, x: 3, y: 3)
                        .padding(.bottom, 19)
                        .disabled(isLoginProcessing)
                        
                        //Email sign in: 테스트용 이메일을 사용하기 위한 것으로 배포시 삭제 예정입니다.
//                        NavigationLink {
//                            EmailLoginView()
//                        } label: {
//                            HStack(spacing: 0) {
//                                Text("테스트용 이메일 계정으로")
//                                    .foregroundColor(postieColors.tabBarTintColor)
//                                
//                                Text("로그인 하기")
//                                    .foregroundColor(postieColors.tintColor)
//                                    .bold()
//                                    .padding(.leading, 4)
//                            }
//                        }
//                        .padding(.bottom, 10)
                    }
                    .padding(.horizontal, 32)
                    
                    if isLoginProcessing {
                        LoadingView(text: "포스티 시작하는 중").background(ClearBackground())
                    }
                }
            }
        }
        .customOnChange(authManager.authDataResult) { newValue in
            if newValue != nil {
                isLoginProcessing = true
            } else {
                isLoginProcessing = false
            }
        }
    }
    
    func loginFailure(error: Error) {
        let error = error as NSError
        
        do {
            if error.code == GIDSignInErrorCode.canceled.rawValue {
                throw GIDSignInErrorCode.canceled
            } else {
                try authManager.authErrorCodeConverter(error: error)
            }
        } catch {
            switch error {
            case AuthErrorCodeCase.userMismatch:
                alertBody = "현재 로그인중인 사용자가 아니에요. 계정을 다시 확인해 주세요."
                showAlert = true
            case GIDSignInErrorCode.canceled:
                alertBody = "로그인을 취소하셨습니다. 다시 시도해 주세요."
                showAlert = false
            case AuthErrorCodeCase.requiresRecentLogin:
                alertBody = "로그인을 취소하셨습니다. 다시 시도해 주세요."
                showAlert = false
            case AuthErrorCodeCase.invalidCredential:
                alertBody = "인증에 실패하였습니다. 다시 시도해 주세요."
                showAlert = true
            default:
                alertBody = "알 수 없는 오류가 발생하였습니다. 지속적으로 오류가 발생한다면 관리자에게 문의해 주세요.\nteam.postie@google.com"
                Logger.auth.error("\(#function) Failed to delete Google account: \(error)")
            }
        }
    }
}

#Preview {
    LoginView()
}
