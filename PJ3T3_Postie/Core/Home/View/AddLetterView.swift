//
//  AddLetterView.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 1/17/24.
//

import SwiftUI

struct AddLetterView: View {
    @StateObject private var addLetterViewModel = AddLetterViewModel()
    @ObservedObject var firestoreManager = FirestoreManager.shared
    @ObservedObject var storageManager = StorageManager.shared


    enum Field: Hashable {
        case sender
        case receiver
        case text
    }

    var isReceived: Bool
    var letter: Letter?
    var letterPhotos: [LetterPhoto]?

    @FocusState private var focusField: Field?
    @Environment(\.dismiss) var dismiss

    init(isReceived: Bool, letter: Letter? = nil, letterPhotos: [LetterPhoto]? = nil) {
        self.isReceived = isReceived
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
            Color(hex: 0xF5F1E8)
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
        .toolbarBackground(Color(hex: 0xF5F1E8), for: .navigationBar)
        .toolbar {
            ToolbarItemGroup(placement: .principal) {
                Text(isReceived ? "받은 편지 기록" : "보낸 편지 기록")
                    .bold()
                    .foregroundStyle(Color(hex: 0xFF5733))
            }

            ToolbarItemGroup(placement: .topBarTrailing) {
                Button {
                    Task {
                        if let letter = letter {
                            await editLetter(letter: letter)

                        } else {
                            await addLetter()
                        }

                        dismiss()
                    }
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
        .fullScreenCover(isPresented: $addLetterViewModel.showLetterImageFullScreenView) {
            LetterImageFullScreenView(
                images: addLetterViewModel.images,
                pageIndex: $addLetterViewModel.selectedIndex
            )
        }
        .sheet(isPresented: $addLetterViewModel.showUIImagePicker) {
            UIImagePicker(
                sourceType: addLetterViewModel.imagePickerSourceType,
                selectedImages: $addLetterViewModel.images,
                text: $addLetterViewModel.text,
                showTextRecognizerErrorAlert: $addLetterViewModel.showTextRecognizerErrorAlert
            )
        }
        .alert("문자 인식 실패", isPresented: $addLetterViewModel.showTextRecognizerErrorAlert) {

        } message: {
            Text("문자 인식에 실패했습니다. 다시 시도해 주세요.")
        }
        .alert("한 줄 요약", isPresented: $addLetterViewModel.showSummaryAlert) {
            Button("직접 작성") {
                // TODO: 함수로 빼기
                addLetterViewModel.showSummaryTextField = true
            }

            Button("AI 완성") {
                // TODO: 네이버 클로바 API 호출
                addLetterViewModel.showSummaryTextField = true
            }
        }
        .onAppear {
            if let letter = letter {
                if isReceived {
                    addLetterViewModel.sender = letter.writer
                } else {
                    addLetterViewModel.receiver = letter.recipient
                }
                addLetterViewModel.date = letter.date
                addLetterViewModel.text = letter.text
                addLetterViewModel.summary = letter.summary
                addLetterViewModel.images = letterPhotos?.map { $0.image } ?? []
            }
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
        firestoreManager.editLetter(
            documentId: letter.id,
            writer: addLetterViewModel.sender,
            recipient: addLetterViewModel.receiver,
            summary: addLetterViewModel.summary,
            date: addLetterViewModel.date,
            text: addLetterViewModel.text,
            isReceived: isReceived,
            isFavorite: letter.isFavorite
        )

        if var savedLetterPhotos = letterPhotos {
            var uiImagesAndFullPaths = savedLetterPhotos.map { (image: $0.image , fullPath: $0.fullPath)}

            for uiImageAndFullPath in uiImagesAndFullPaths {
                if !addLetterViewModel.images.contains(uiImageAndFullPath.image) {
                    if let index = uiImagesAndFullPaths.firstIndex(where: { $0 == uiImageAndFullPath }) {
                        uiImagesAndFullPaths.remove(at: index)
                        storageManager.deleteItem(fullPath: uiImageAndFullPath.fullPath)
                    }
                }
            }

            for image in addLetterViewModel.images {
                if !uiImagesAndFullPaths.map( { $0.image } ).contains(image) {
                    do {
                        try await storageManager.saveUIImage(images: [image], docId: letter.id)
                    } catch {
                        // TODO: ERROR 처리 필요
                        print("DEBUG: 이미지 저장 실패")
                    }
                }
            }

            storageManager.images.removeAll()
            
            storageManager.listAllFile(docId: letter.id)
        }

        firestoreManager.letter = Letter(
            id: letter.id,
            writer: addLetterViewModel.sender,
            recipient: addLetterViewModel.receiver,
            summary: addLetterViewModel.summary,
            date: addLetterViewModel.date,
            text: addLetterViewModel.text,
            isReceived: isReceived,
            isFavorite: letter.isFavorite
        )

        firestoreManager.fetchAllLetters()
    }
    
    /// 편지를 추가합니다
    ///
    /// 1. Firestore에 편지 추가
    /// 2. 편지 이미지 값이 존재하면 Firestorage에 이미지 추가
    /// 3. 모든 편지 불러와서 상태 업데이트
    private func addLetter() async {
        await firestoreManager.addLetter(
            writer: isReceived ? addLetterViewModel.sender : AuthManager.shared.currentUser?.fullName ?? "유저",
            recipient: isReceived ? AuthManager.shared.currentUser?.fullName ?? "유저" : addLetterViewModel.receiver,
            summary: addLetterViewModel.summary,
            date: addLetterViewModel.date,
            text: addLetterViewModel.text,
            isReceived: isReceived,
            isFavorite: false
        )

        if !addLetterViewModel.images.isEmpty {
            do {
                try await storageManager.saveUIImage(
                    images: addLetterViewModel.images,
                    docId: firestoreManager.docId
                )
            } catch {
                // TODO: Error 처리 필요
                print("DEBUG: Failed to save UIImages to Firestore: \(error)")
            }
        }

        firestoreManager.fetchAllLetters()
    }
}

// MARK: - Computed Views

extension AddLetterView {
    @ViewBuilder
    private var letterInfoSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(isReceived ? "보낸 사람" : "받는 사람")

                TextField("",
                          text: isReceived ?
                          $addLetterViewModel.sender : $addLetterViewModel.receiver)
                .padding(6)
                .background(Color(hex: 0xFCFBF7))
                .clipShape(RoundedRectangle(cornerRadius: 4))
                .focused($focusField, equals: .sender)
            }
            .frame(maxWidth: .infinity)

            VStack(alignment: .leading, spacing: 4) {
                Text(isReceived ? "받은 날짜" : "보낸 날짜")

                DatePicker(
                    "",
                    selection: $addLetterViewModel.date,
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
                        addLetterViewModel.showUIImagePicker(sourceType: .photoLibrary)
                    } label: {
                        HStack {
                            Text("사진 보관함")

                            Spacer()

                            Image(systemName: "photo.on.rectangle")
                        }
                    }

                    Button {
                        addLetterViewModel.showUIImagePicker(sourceType: .camera)
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

            if addLetterViewModel.images.isEmpty {
                Label("사진을 추가해주세요.", systemImage: "photo.on.rectangle")
                    .foregroundStyle(Color(hex: 0xAAAAAA))
                    .frame(maxWidth: .infinity)
                    .frame(height: 100)
                    .frame(alignment: .center)
            } else {
                ScrollView(.horizontal) {
                    HStack(spacing: 8) {
                        ForEach(0..<addLetterViewModel.images.count, id: \.self) { index in
                            ZStack(alignment: .topTrailing) {
                                Button {
                                    addLetterViewModel.selectedIndex = index
                                    addLetterViewModel.showLetterImageFullScreenView = true
                                } label: {
                                    Image(uiImage: addLetterViewModel.images[index])
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .clipShape(RoundedRectangle(cornerRadius: 4))
                                }

                                Button {
                                    withAnimation {
                                        addLetterViewModel.removeImage(at: index)
                                    }
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .symbolRenderingMode(.palette)
                                        .foregroundStyle(.white, Color(hex: 0xFF5733))
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
                if addLetterViewModel.text.isEmpty {
                    TextEditor(text: .constant("사진을 등록하면 자동으로 편지 내용이 입력됩니다."))
                        .scrollContentBackground(.hidden)
                        .background(Color(hex: 0xFCFBF7))
                        .lineSpacing(5)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                        .frame(maxWidth: .infinity)
                        .frame(height: 350)
                        .disabled(true)
                }

                TextEditor(text: $addLetterViewModel.text)
                    .scrollContentBackground(.hidden)
                    .background(Color(hex: 0xFCFBF7))
                    .lineSpacing(5)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(.black, lineWidth: 1 / 4)
                            .opacity(0.2)
                    )
                    .frame(maxWidth: .infinity)
                    .frame(height: 350)
                    .opacity(addLetterViewModel.text.isEmpty ? 0.25 : 1)
                    .focused($focusField, equals: .text)
            }
        }

        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("한 줄 요약")

                Spacer()

                Button {
                    addLetterViewModel.showSummaryAlert = true
                } label: {
                    Image(systemName: "plus")
                }
            }

            if addLetterViewModel.showSummaryTextField || !addLetterViewModel.summary.isEmpty {
                TextField("", text: $addLetterViewModel.summary)
                    .padding(6)
                    .background(Color(hex: 0xFCFBF7))
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                    .focused($focusField, equals: .receiver)
            } else {
                Label("편지를 요약해드릴게요.", systemImage: "text.quote.rtl")
                    .foregroundStyle(Color(hex: 0xAAAAAA))
                    .frame(maxWidth: .infinity)
                    .frame(height: 30)
                    .frame(alignment: .center)

            }
        }
    }
}

#Preview {
    NavigationStack {
        AddLetterView(isReceived: false)
    }
}
