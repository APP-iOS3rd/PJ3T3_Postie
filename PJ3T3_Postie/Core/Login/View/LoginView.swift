//
//  LoginView.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 1/17/24.
//

import SwiftUI

struct LoginView: View {
    //Colors
    private let viewBackground: Color = .white
    private let buttonColor: Color = Color(uiColor: .darkGray)
    //ViewModels
    @ObservedObject var authViewModel = AuthViewModel.shared
    //TextFields의 input값을 하위뷰에 넘겨준다.
    @State private var email = ""
    @State private var password = ""
    
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
                        LoginInputView(title: "Email Address",
                                       placeholder: "name@example.com",
                                       text: $email)
                        .textInputAutocapitalization(.never)

                        LoginInputView(title: "Password",
                                       placeholder: "Enter your password",
                                       isSecureField: true,
                                       text: $password)
                    }
                    .padding(.horizontal)
                    .padding(.top, 12)

                    //Sign in Button
                    Button {
                        Task {
                            try await authViewModel.signIn(withEamil: email, password: password)
                        }
                    } label: {
                        HStack {
                            Text("SIGN IN")
                                .fontWeight(.semibold)
                            
                            Image(systemName: "arrow.right")
                        }
                        .foregroundColor(.white)
                        .frame(height: 48)
                        .padding(.horizontal, 32)
                    }
                    .background(buttonColor)
                    .disabled(!formIsValid)
                    .opacity(formIsValid ? 1.0 : 0.5)
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
    }
}

extension LoginView: AuthenticationProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
    }
}

#Preview {
    LoginView()
}
