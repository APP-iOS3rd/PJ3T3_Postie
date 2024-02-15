//
//  LetterDetailView.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 1/17/24.
//

import SwiftUI

struct LetterDetailView: View {
    @StateObject private var letterDetailViewModel = LetterDetailViewModel()
    @ObservedObject var firestoreManager = FirestoreManager.shared
    @ObservedObject var storageManager = StorageManager.shared

    @Environment(\.dismiss) var dismiss
    @AppStorage("isThemeGroupButton") private var isThemeGroupButton: Int = 0

    var letter: Letter

    var body: some View {
        
        ZStack {
            ThemeManager.themeColors[isThemeGroupButton].backGroundColor
                .ignoresSafeArea()
            
            VStack {
                Page(letter: $firestoreManager.letter)

                letterSummarySection

                letterImageSection
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(ThemeManager.themeColors[isThemeGroupButton].backGroundColor, for: .navigationBar)
        .toolbar {
            ToolbarItemGroup(placement: .principal) {
                Text(letter.isReceived ? "받은 편지" : "보낸 편지")
                    .bold()
                    .foregroundStyle(ThemeManager.themeColors[isThemeGroupButton].tintColor)
            }

            ToolbarItemGroup(placement: .topBarTrailing) {
                Button {
                    letterDetailViewModel.isFavorite.toggle()
                    
                    // TODO: 하나만 업데이트 하는 함수로 변경
                    firestoreManager.editLetter(
                        documentId: letter.id,
                        writer: firestoreManager.letter.writer,
                        recipient: firestoreManager.letter.recipient,
                        summary: firestoreManager.letter.summary,
                        date: firestoreManager.letter.date,
                        text: firestoreManager.letter.text,
                        isReceived: firestoreManager.letter.isReceived,
                        isFavorite: letterDetailViewModel.isFavorite
                    )

                    firestoreManager.fetchAllLetters()
                } label: {
                    Image(systemName: letterDetailViewModel.isFavorite ? "heart.fill" : "heart")
                        .foregroundStyle(.postieOrange)
                }

                Menu {
                    Button {
                        letterDetailViewModel.showLetterEditSheet = true
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
                images: storageManager.images.map { $0.image },
                pageIndex: $letterDetailViewModel.selectedIndex
            )
        }
        .sheet(isPresented: $letterDetailViewModel.showLetterEditSheet) {
            NavigationStack {
                EditLetterView(letter: letter, letterPhotos: StorageManager.shared.images)
            }
        }
        .alert("편지 삭제", isPresented: $letterDetailViewModel.showDeleteAlert) {
            Button(role: .cancel) {

            } label: {
                Text("취소")
            }

            Button(role: .destructive) {
                firestoreManager.deleteLetter(documentId: letter.id)

                storageManager.images.forEach { letterPhoto in
                    storageManager.deleteItem(fullPath: letterPhoto.fullPath)
                }

                firestoreManager.fetchAllLetters()

                dismiss()
            } label: {
                Text("삭제")
            }
        } message: {
            Text("편지를 삭제하시겠습니까?")
        }
        .onAppear {
            storageManager.listAllFile(docId: letter.id)

            letterDetailViewModel.isFavorite = letter.isFavorite

            firestoreManager.letter = letter
        }
        .onDisappear {
            storageManager.images.removeAll()
        }
    }
}

// MARK: - Computed Views

extension LetterDetailView {
    @ViewBuilder
    private var letterSummarySection: some View {
        if !firestoreManager.letter.summary.isEmpty {
            VStack(alignment: .leading, spacing: 4) {
                Text("한 줄 요약")

                Text(firestoreManager.letter.summary)
                    .font(.letter(.nanumMyeongjo))
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(ThemeManager.themeColors[isThemeGroupButton].receivedLetterColor)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
            }
        }
    }

    @ViewBuilder
    private var letterImageSection: some View {
        if !storageManager.images.isEmpty {
            VStack(alignment: .leading, spacing: 4) {
                Text("편지 사진")

                ScrollView(.horizontal) {
                    HStack(spacing: 8) {
                        ForEach(0..<storageManager.images.count, id: \.self) { index in
                            ZStack {
                                Button {
                                    letterDetailViewModel.selectedIndex = index
                                    letterDetailViewModel.showLetterImageFullScreenView = true
                                } label: {
                                    Image(uiImage: storageManager.images.map({$0.image})[index])
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 50, height: 50)
                                        .clipShape(RoundedRectangle(cornerRadius: 4))
                                }
                            }
                        }
                    }
                }
                .scrollIndicators(.never)
            }
        }
    }
}

#Preview {
    NavigationStack {
        LetterDetailView(letter: Letter.preview)
    }
}
