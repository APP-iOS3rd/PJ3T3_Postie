//
//  LetterImageFullScreenView.swift
//  PJ3T3_Postie
//
//  Created by KHJ on 2024/01/17.
//

import SwiftUI

struct LetterImageFullScreenView: View {
    let images: [UIImage]

    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            TabView {
                ForEach(0..<images.count, id: \.self) { index in
                    Image(uiImage: images[index])
                        .resizable()
                        .scaledToFit()
                }
            }
            .tabViewStyle(.page)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
    }
}

//#Preview {
//    LetterImageFullScreenView()
//}
