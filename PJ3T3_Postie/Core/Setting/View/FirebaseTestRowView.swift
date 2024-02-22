//
//  FirebaseTestRowView.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 1/17/24.
//

import SwiftUI

struct FirebaseTestRowView: View {
    let imageName: String
    let title: String
    let tintColor: Color
    //Colors
    private let fontColor: Color = .black
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: imageName)
                .imageScale(.small)
                .font(.title)
                .foregroundStyle(tintColor)

            Text(title)
                .font(.subheadline)
                .foregroundStyle(fontColor)
        }
    }
}

#Preview {
    FirebaseTestRowView(imageName: "gear", title: "Version", tintColor: Color(uiColor: .darkGray))
}
