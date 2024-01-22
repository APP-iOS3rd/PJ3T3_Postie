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
                Page(letter: letter)

                letterImageSection
            }
            .padding()
        }
        .navigationTitle("편지 정보")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color(hex: 0xF5F1E8), for: .navigationBar)
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Menu {
                    Button {

                    } label: {
                        Text("수정")
                    }

                    Button(role: .destructive) {
                        letterDetailViewModel.showDeleteAlert = true
                    } label: {
                        Text("삭제")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                }

            }
        }
        .fullScreenCover(isPresented: $letterDetailViewModel.showLetterImageFullScreenView) {
            LetterImageFullScreenView(
                images: letter.images ?? [],
                pageIndex: $letterDetailViewModel.selectedIndex
            )
        }
        .alert("편지 삭제", isPresented: $letterDetailViewModel.showDeleteAlert) {
            Button(role: .cancel) {

            } label: {
                Text("취소")
            }

            Button(role: .destructive) {
                // Delete
            } label: {
                Text("삭제")
            }
        } message: {
            Text("편지를 삭제하시겠습니까?")
        }
    }
}

// MARK: - Computed Views

extension LetterDetailView {
    private var letterImageSection: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 8) {
                if let images = letter.images {
                    ForEach(0..<images.count, id: \.self) { index in
                        ZStack {
                            Button {
                                letterDetailViewModel.selectedIndex = index
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
        .padding(.top, 8)
        .scrollIndicators(.never)
    }
}
#Preview {
    NavigationStack {
        LetterDetailView(letter: Letter.preview)
    }
}
