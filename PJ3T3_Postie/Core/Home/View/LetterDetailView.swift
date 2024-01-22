//
//  LetterDetailView.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 1/17/24.
//

import SwiftUI

struct LetterDetailView: View {
    var letter: Letter

    @StateObject private var letterDetailViewModel = LetterDetailViewModel()

    var body: some View {
        ZStack {
            Color(hex: 0xF5F1E8)
                .ignoresSafeArea()
            
            VStack {
                Page(letter: letter, text: letter.text)
                    .background(Color(hex: 0xFFFBF2))
                    .clipShape(RoundedRectangle(cornerRadius: 10.0))
                    .padding(.bottom, 8)

                ScrollView(.horizontal) {
                    HStack(spacing: 8) {
                        if let images = letter.images {
                            ForEach(0..<images.count, id: \.self) { index in
                                ZStack {
                                    Button {
                                        letterDetailViewModel.showLetterImageFullScreenView = true
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
        .toolbarBackground(Color(hex: 0xF5F1E8), for: .navigationBar)
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button {
                    // show delete alert
                } label: {
                    Text("삭제")
                }
            }
        }
        .fullScreenCover(isPresented: $letterDetailViewModel.showLetterImageFullScreenView) {
            LetterImageFullScreenView(images: letter.images ?? [])
        }
    }
}

#Preview {
    NavigationStack {
        LetterDetailView(letter: Letter.preview)
    }
}
