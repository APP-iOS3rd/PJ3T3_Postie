//
//  RegistrationView.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 1/17/24.
//

import SwiftUI

struct RegistrationView: View {
    //Colors
    private let viewBackground: Color = .white
    private let buttonColor: Color = Color(uiColor: .darkGray)
    //뷰를 해제하는 기능 설정
    @Environment(\.dismiss) var dismiss
    //TextFields의 input값을 하위뷰에 넘겨준다.
    @State private var email = ""
    @State private var fullName = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(viewBackground)
                .ignoresSafeArea()

            VStack {
                //Image
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

                    LoginInputView(title: "Full Name",
                                   placeholder: "Enter your name",
                                   text: $fullName)

                    LoginInputView(title: "Password",
                                   placeholder: "Enter your password",
                                   isSecureField: true,
                                   text: $password)

                    LoginInputView(title: "Confirm password",
                                   placeholder: "Confirm your password",
                                   isSecureField: true,
                                   text: $confirmPassword)
                } //VStack
                .padding(.horizontal)
                .padding(.top, 12)

                //Sign in Button
                Button {
                    print(#function)
                } label: {
                    HStack {
                        Text("SIGN UP")
                            .fontWeight(.semibold)
                        
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(.white)
                    .frame(height: 48)
                    .padding(.horizontal, 32)
                }
                .background(buttonColor)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.top, 24)

                Spacer()

                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 3) {
                        Text("Already have an account?")
                        
                        Text("Sign in")
                            .fontWeight(.bold)
                    }
                    .font(.system(size: 14))
                }
            } //VStack
        } //ZStack
    }
}

#Preview {
    RegistrationView()
}
