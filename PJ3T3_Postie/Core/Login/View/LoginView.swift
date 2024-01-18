//
//  LoginView.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 1/17/24.
//

import SwiftUI

struct LoginView: View {
    //TextFields의 input값을 하위뷰에 넘겨준다.
    @State private var email = ""
    @State private var password = ""
    //버튼 width를 정하기 위해 screen size를 받아온다.
    @State private var screenWidth: CGFloat = 0
    private let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
    //Colors
    private let viewBackground: Color = .white
    private let buttonColor: Color = Color(uiColor: .darkGray)
    
    var body: some View {
        NavigationStack {
            ZStack {
                Rectangle()
                    .foregroundStyle(viewBackground)
                    .ignoresSafeArea()
                
                VStack {
                    Image(systemName: "archivebox")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .padding(.vertical, 36)

                    //Form fields
                    VStack(spacing: 24) {
                        LoginInputView(text: $email,
                                  title: "Email Address",
                                  placeholder: "name@example.com")
                        .textInputAutocapitalization(.never)

                        LoginInputView(text: $password,
                                  title: "Password",
                                  placeholder: "Enter your password",
                                  isSecureField: true)
                    }
                    .padding(.horizontal)
                    .padding(.top, 12)

                    //Sign in Button
                    Button {
                        print(#function)
                    } label: {
                        HStack {
                            Text("SIGN IN")
                                .fontWeight(.semibold)
                            
                            Image(systemName: "arrow.right")
                        }
                        .foregroundColor(.white)
                        .frame(width: screenWidth - 32,
                               height: 48)
                    }
                    .background(buttonColor)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.top, 24)

                    Spacer()

                    //Sign up Button
                    NavigationLink {
                        RegistrationView()
                            .navigationBarBackButtonHidden()
                    } label: {
                        HStack(spacing: 3) {
                            Text("Don't have an account?")
                            
                            Text("Sign up")
                                .fontWeight(.bold)
                        }
                        .font(.system(size: 14))
                    }
                } //VStack
            } //ZStack
        } //NavigationStack
        .onAppear {
            screenWidth = windowScene?.screen.bounds.width ?? 1.0
        }
    }
}

#Preview {
    LoginView()
}
