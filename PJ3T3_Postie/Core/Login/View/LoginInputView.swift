//
//  InputView.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 1/17/24.
//

import SwiftUI

//reusable component
struct LoginInputView: View {
    //Colors
    private let fontColor: Color = .black
    //해당 뷰를 호출할 때 값을 채워주어야 하는 부분
    let title: String
    let placeholder: String
    var isSecureField = false
    @Binding var text: String
    
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
    LoginInputView(title: "Email Address", placeholder: "name@example.com", text: .constant(""))
}
