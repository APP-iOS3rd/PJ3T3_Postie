//
//  LetterDetailView.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 1/17/24.
//

import SwiftUI

struct LetterDetailView: View {
    var controllers: [UIHostingController<Page>]

    init(letter: Letter) {
        controllers = letter.text.chunks(size: 400).map { chunk in
            UIHostingController(rootView: Page(letter: letter, chunk: chunk))
        }
    }

    var body: some View {
        ZStack {
            Color(hex: 0xF5F1E8)
                .ignoresSafeArea()
            
            VStack {
                PageViewController(controllers: controllers)
                    .clipShape(RoundedRectangle(cornerRadius: 10.0))
            }
            .padding()
        }
        .navigationTitle("편지 정보")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button {
                    // show delete alert
                } label: {
                    Image(systemName: "trash")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        LetterDetailView(letter: Letter.preview)
    }
}
