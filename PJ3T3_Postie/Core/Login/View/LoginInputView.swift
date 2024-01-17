//
//  InputView.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 1/17/24.
//

import SwiftUI

//reusable component
struct LoginInputView: View {
    @Binding var text: String
    let title: String
    let placeholder: String
    var isSecureField = false
    //Colors
    private let fontColor: Color = .black
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .foregroundStyle(fontColor)
                .fontWeight(.semibold)
                .font(.footnote)

            if isSecureField {
                SecureField(placeholder, text: $text)
            } else {
                TextField(placeholder, text: $text)
            }

            Divider()
        }
    }
}

#Preview {
    LoginInputView(text: .constant(""), title: "Email Address", placeholder: "name@example.com")
}
