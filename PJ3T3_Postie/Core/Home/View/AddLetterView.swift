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

    var isSendingLetter: Bool
    let dateFormatter: DateFormatter = {
         let formatter = DateFormatter()
         formatter.dateFormat = "yyyy.MM.dd"
         return formatter
     }()

    @FocusState private var focusField: Field?
    @Environment(\.dismiss) var dismiss

    init(isSendingLetter: Bool) {
        self.isSendingLetter = isSendingLetter

        // TextEditor 패딩
        UITextView.appearance().textContainerInset = UIEdgeInsets(
            top: 12,
            left: 8,
            bottom: 12,
            right: 8
        )
    }

    var body: some View {
        NavigationStack {
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
            .navigationTitle(isSendingLetter ? "보낸 편지 기록" : "받은 편지 기록")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color(hex: 0xF5F1E8), for: .navigationBar)
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                        Task {
                            await firestoreManager.addLetter(
                                writer: addLetterViewModel.sender,
                                recipient: addLetterViewModel.receiver,
                                summary: addLetterViewModel.summary,
                                date: addLetterViewModel.date,
                                text: addLetterViewModel.text
                            )

                            if !addLetterViewModel.images.isEmpty {
                                do {
                                    try await storageManager.saveUIImage(
                                        images: addLetterViewModel.images,
                                        userId: firestoreManager.userUid,
                                        docId: firestoreManager.docId
                                    )
                                } catch {
                                    // TODO: Error 처리 필요
                                    print("DEBUG: Failed to save UIImages to Firestore: \(error)")
                                }
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
            .alert("", isPresented: $addLetterViewModel.showTextRecognizerErrorAlert, actions: {
                
            })
            .confirmationDialog("편지 사진 가져오기",
                                isPresented: $addLetterViewModel.showConfirmationDialog) {
                Button("카메라") {
                    addLetterViewModel.showUIImagePicker(sourceType: .camera)
                }

                Button("앨범") {
                    addLetterViewModel.showUIImagePicker(sourceType: .photoLibrary)
                }

                Button("스캐너") {

                }
            } message: {
                Text("편지 사진 가져오기")
            }
        }
    }
}

// MARK: - Computed Views

extension AddLetterView {
    @ViewBuilder
    private var letterInfoSection: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text(isSendingLetter ? "받는 사람" : "보낸 사람")

                TextField("", 
                          text: isSendingLetter ? 
                          $addLetterViewModel.sender : $addLetterViewModel.receiver)
                .padding(6)
                .background(Color(hex: 0xFCFBF7))
                .clipShape(RoundedRectangle(cornerRadius: 4))
                .focused($focusField, equals: .sender)
            }
            .frame(width: UIScreen.main.bounds.width * 0.5)

            VStack(alignment: .leading, spacing: 4) {
                Text(isSendingLetter ? "보낸 날짜" : "받은 날짜")

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

                Button {
                    addLetterViewModel.showConfirmationDialog = true
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
                            ZStack {
                                Button {
                                    addLetterViewModel.selectedIndex = index
                                    addLetterViewModel.showLetterImageFullScreenView = true
                                } label: {
                                    Image(uiImage: addLetterViewModel.images[index])
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                }

                                VStack {
                                    HStack {
                                        Spacer()

                                        Button {
                                            withAnimation {
                                                addLetterViewModel.removeImage(at: index)
                                            }
                                        } label: {
                                            Image(systemName: "x.circle")
                                        }
                                        .padding(4)
                                    }
                                    Spacer()
                                }
                            }
                        }
                    }
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
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .frame(maxWidth: .infinity)
                        .frame(height: 350)
                        .disabled(true)
                }
                TextEditor(text: $addLetterViewModel.text)
                    .scrollContentBackground(.hidden)
                    .background(Color(hex: 0xFCFBF7))
                    .lineSpacing(5)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
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
                    // TODO: 요약 진행 Alert 띄우기
                } label: {
                    Image(systemName: "plus")
                }
            }

            if addLetterViewModel.summary.isEmpty {
                Label("편지를 요약해드릴게요.", systemImage: "text.quote.rtl")
                    .foregroundStyle(Color(hex: 0xAAAAAA))
                    .frame(maxWidth: .infinity)
                    .frame(height: 30)
                    .frame(alignment: .center)
            } else {
                TextField("", text: $addLetterViewModel.summary)
                    .padding(6)
                    .background(Color(hex: 0xFCFBF7))
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                    .focused($focusField, equals: .receiver)
            }
        }
    }
}

#Preview {
    NavigationStack {
        AddLetterView(isSendingLetter: false)
    }
}
