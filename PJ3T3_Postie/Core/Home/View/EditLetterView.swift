//
//  EditLetterView.swift
//  PJ3T3_Postie
//
//  Created by KHJ on 2024/02/14.
//

import SwiftUI

struct EditLetterView: View {
    @StateObject private var editLetterViewModel = EditLetterViewModel()

    enum Field: Hashable {
        case sender
        case receiver
        case text
        case summary
    }

    let letter: Letter
    var letterPhotos: [LetterPhoto]

    @FocusState private var focusField: Field?
    @Environment(\.dismiss) var dismiss
    @AppStorage("isThemeGroupButton") private var isThemeGroupButton: Int = 0

    init(letter: Letter, letterPhotos: [LetterPhoto]) {
        self.letter = letter
        self.letterPhotos = letterPhotos

        // TextEditor 패딩
        UITextView.appearance().textContainerInset = UIEdgeInsets(
            top: 12,
            left: 8,
            bottom: 12,
            right: 8
        )
    }

    var body: some View {
        ZStack {
            ThemeManager.themeColors[isThemeGroupButton].backGroundColor
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    letterInfoSection

                    letterImagesSection

                    letterTextSection
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(ThemeManager.themeColors[isThemeGroupButton].backGroundColor, for: .navigationBar)
        .toolbar {
            ToolbarItemGroup(placement: .principal) {
                Text(letter.isReceived ? "받은 편지 기록" : "보낸 편지 기록")
                    .bold()
                    .foregroundStyle(ThemeManager.themeColors[isThemeGroupButton].tintColor)
            }

            ToolbarItemGroup(placement: .topBarTrailing) {
                Button {
                    Task {
                        await editLetter(letter: letter)

                    }

                    dismiss()
                } label : {
                    Text("완료")
                }
            }

            ToolbarItemGroup(placement: .keyboard) {
                Spacer()

                Button {
                    focusField = nil
                } label: {
                    Image(systemName: "keyboard.chevron.compact.down")
                }
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .scrollDismissesKeyboard(.interactively)
        .fullScreenCover(isPresented: $editLetterViewModel.showLetterImageFullScreenView) {
            LetterImageFullScreenView(
                images: editLetterViewModel.images,
                pageIndex: $editLetterViewModel.selectedIndex
            )
        }
        .sheet(isPresented: $editLetterViewModel.showUIImagePicker) {
            UIImagePicker(
                sourceType: editLetterViewModel.imagePickerSourceType,
                selectedImages: $editLetterViewModel.images,
                text: $editLetterViewModel.text,
                showTextRecognizerErrorAlert: $editLetterViewModel.showTextRecognizerErrorAlert
            )
            .ignoresSafeArea(.all, edges: .bottom)
        }
        .alert("문자 인식 실패", isPresented: $editLetterViewModel.showTextRecognizerErrorAlert) {

        } message: {
            Text("문자 인식에 실패했습니다. 다시 시도해 주세요.")
        }
        .alert("한 줄 요약", isPresented: $editLetterViewModel.showSummaryAlert) {
            Button("직접 작성") {
                // TODO: 함수로 빼기
                editLetterViewModel.showSummaryTextField = true
                focusField = .summary
            }

            Button("AI 완성") {
                // TODO: 네이버 클로바 API 호출
                editLetterViewModel.showSummaryTextField = true
                focusField = .summary
            }
        }
        .onAppear {
            editLetterViewModel.sender = letter.writer
            editLetterViewModel.receiver = letter.recipient
            editLetterViewModel.date = letter.date
            editLetterViewModel.text = letter.text
            editLetterViewModel.summary = letter.summary
            editLetterViewModel.images = letterPhotos.map { $0.image }

            editLetterViewModel.showSummaryTextField = !letter.summary.isEmpty
        }
    }

    /// 이미 작성된 편지를 수정합니다.
    /// - Parameter letter: 작성된 편지
    ///
    /// 1. Firestore에 저장된 편지 데이터를 수정
    /// 2. Firestorage에 저장된 편지 이미지를 수정 후 불러와 데이터 상태 업데이트
    /// 3. FirestoreManager의 @Published letter 변수 업데이트 ( AddView, DetailView 연동을 위해서 )
    /// 4. `firestoreManager.fetchAllLetters()`을 홈뷰, 디테일뷰 데이터 상태 업데이트
    private func editLetter(letter: Letter) async {
        FirestoreManager.shared.editLetter(
            documentId: letter.id,
            writer: editLetterViewModel.sender,
            recipient: editLetterViewModel.receiver,
            summary: editLetterViewModel.summary,
            date: editLetterViewModel.date,
            text: editLetterViewModel.text,
            isReceived: letter.isReceived,
            isFavorite: letter.isFavorite
        )

        FirestoreManager.shared.letter = Letter(
            id: letter.id,
            writer: editLetterViewModel.sender,
            recipient: editLetterViewModel.receiver,
            summary: editLetterViewModel.summary,
            date: editLetterViewModel.date,
            text: editLetterViewModel.text,
            isReceived: letter.isReceived,
            isFavorite: letter.isFavorite
        )

        FirestoreManager.shared.fetchAllLetters()
    }
}

// MARK: - Computed Views

extension EditLetterView {
    @ViewBuilder
    private var letterInfoSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(letter.isReceived ? "보낸 사람" : "받는 사람")

                TextField("",
                          text: letter.isReceived ?
                          $editLetterViewModel.sender : $editLetterViewModel.receiver)
                .padding(6)
                .background(ThemeManager.themeColors[isThemeGroupButton].receivedLetterColor)
                .clipShape(RoundedRectangle(cornerRadius: 4))
                .focused($focusField, equals: .sender)
            }
            .frame(maxWidth: .infinity)

            VStack(alignment: .leading, spacing: 4) {
                Text(letter.isReceived ? "받은 날짜" : "보낸 날짜")

                DatePicker(
                    "",
                    selection: $editLetterViewModel.date,
                    displayedComponents: .date
                )
                .labelsHidden()
                .environment(\.locale, Locale.init(identifier: "ko"))
            }
        }
    }

    @ViewBuilder
    private var letterImagesSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("편지 사진")

                Spacer()

                Menu {
                    Button {
                        editLetterViewModel.showUIImagePicker(sourceType: .photoLibrary)
                    } label: {
                        HStack {
                            Text("사진 보관함")

                            Spacer()

                            Image(systemName: "photo.on.rectangle")
                        }
                    }

                    Button {
                        editLetterViewModel.showUIImagePicker(sourceType: .camera)
                    } label: {
                        HStack {
                            Text("사진 찍기")

                            Spacer()

                            Image(systemName: "camera")
                        }
                    }
                } label: {
                    Image(systemName: "plus")
                }
            }

            if StorageManager.shared.images.isEmpty {
                Label("사진을 추가해주세요.", systemImage: "photo.on.rectangle")
                    .foregroundStyle(ThemeManager.themeColors[isThemeGroupButton].dividerColor)
                    .frame(maxWidth: .infinity)
                    .frame(height: 100)
                    .frame(alignment: .center)
            } else {
                ScrollView(.horizontal) {
                    HStack(spacing: 8) {
                        ForEach(0..<StorageManager.shared.images.count, id: \.self) { index in
                            ZStack(alignment: .topTrailing) {
                                Button {
                                    editLetterViewModel.selectedIndex = index
                                    editLetterViewModel.showLetterImageFullScreenView = true
                                } label: {
                                    Image(uiImage: StorageManager.shared.images.map({$0.image}) [index])
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .clipShape(RoundedRectangle(cornerRadius: 4))
                                }

                                Button {
                                    withAnimation {
                                        let selectedLetterPhoto = StorageManager.shared.images[index]
                                        StorageManager.shared.deleteItem(fullPath: selectedLetterPhoto.fullPath)
                                    }
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .symbolRenderingMode(.palette)
                                        .foregroundStyle(.white, ThemeManager.themeColors[isThemeGroupButton].tintColor)
                                }
                                .offset(x: 8, y: -8)
                            }
                        }
                    }
                    .padding(.top, 8)
                }
                .scrollIndicators(.never)
            }
        }
    }

    @ViewBuilder
    private var letterTextSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("내용")

            ZStack {
                if editLetterViewModel.text.isEmpty {
                    TextEditor(text: .constant("사진을 등록하면 자동으로 편지 내용이 입력됩니다."))
                        .scrollContentBackground(.hidden)
                        .background(ThemeManager.themeColors[isThemeGroupButton].receivedLetterColor)
                        .lineSpacing(5)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                        .frame(maxWidth: .infinity)
                        .frame(height: 350)
                        .disabled(true)
                }

                TextEditor(text: $editLetterViewModel.text)
                    .scrollContentBackground(.hidden)
                    .background(ThemeManager.themeColors[isThemeGroupButton].receivedLetterColor)
                    .lineSpacing(5)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(.black, lineWidth: 1 / 4)
                            .opacity(0.2)
                    )
                    .frame(maxWidth: .infinity)
                    .frame(height: 350)
                    .opacity(editLetterViewModel.text.isEmpty ? 0.25 : 1)
                    .focused($focusField, equals: .text)
            }
        }

        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("한 줄 요약")

                Spacer()

                Button {
                    editLetterViewModel.showSummaryAlert = true
                } label: {
                    Image(systemName: "plus")
                }
            }

            if editLetterViewModel.showSummaryTextField || !editLetterViewModel.summary.isEmpty {
                TextField("", text: $editLetterViewModel.summary)
                    .padding(6)
                    .background(ThemeManager.themeColors[isThemeGroupButton].receivedLetterColor)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                    .focused($focusField, equals: .summary)
            } else {
                Label("편지를 요약해드릴게요.", systemImage: "text.quote.rtl")
                    .foregroundStyle(ThemeManager.themeColors[isThemeGroupButton].dividerColor)
                    .frame(maxWidth: .infinity)
                    .frame(height: 30)
                    .frame(alignment: .center)

            }
        }
    }
}


#Preview {
    EditLetterView(letter: Letter.preview, letterPhotos: [])
}
