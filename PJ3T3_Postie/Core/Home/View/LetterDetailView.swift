//
//  LetterDetailView.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 1/17/24.
//

import SwiftUI

struct LetterDetailView: View {
    var controllers: [UIHostingController<Page>]
    var letter: Letter

    init(letter: Letter) {
        self.letter = letter
        controllers = letter.text.chunks(size: 300).map { chunk in
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
                    .padding(.bottom, 8)

                ScrollView(.horizontal) {
                    HStack(spacing: 8) {
                        if let images = letter.images {
                            ForEach(0..<images.count, id: \.self) { index in
                                ZStack {
                                    Button {
    //                                    addLetterViewModel.showLetterImageFullScreenView = true
                                    } label: {
                                        Image(uiImage: images[index])
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 50, height: 50)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                    }
                                }
                            }
                        }
                    }
                }
                .scrollIndicators(.never)

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
