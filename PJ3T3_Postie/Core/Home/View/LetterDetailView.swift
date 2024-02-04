//
//  LetterDetailView.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 1/17/24.
//

import SwiftUI

struct LetterDetailView: View {
    @StateObject private var letterDetailViewModel = LetterDetailViewModel()

    var letter: Letter

    var body: some View {
        ZStack {
            Color(hex: 0xF5F1E8)
                .ignoresSafeArea()
            
            VStack {
                Page(letter: letter)

                if !letter.summary.isEmpty {
                    Text(letter.summary)
                        .font(.letter(.nanumMyeongjo))
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(hex: 0xFFFBF2))
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                }

                letterImageSection
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color(hex: 0xF5F1E8), for: .navigationBar)
        .toolbar {
            ToolbarItemGroup(placement: .principal) {
                Text(letter.isReceived ? "받은 편지" : "보낸 편지")
                    .bold()
                    .foregroundStyle(Color(hex: 0xFF5733))
            }

            ToolbarItemGroup(placement: .topBarTrailing) {
                Button {

                } label: {
                    Image(systemName: "heart")
                }

                Menu {
                    Button {

                    } label: {
                        HStack {
                            Text("수정")

                            Image(systemName: "square.and.pencil")
                        }
                    }

                    Button(role: .destructive) {
                        // TODO: 함수로 빼기
                        letterDetailViewModel.showDeleteAlert = true
                    } label: {
                        HStack {
                            Text("삭제")

                            Image(systemName: "trash")
                        }
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
