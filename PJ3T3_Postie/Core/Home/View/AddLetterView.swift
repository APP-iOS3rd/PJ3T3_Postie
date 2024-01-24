//
//  AddLetterView.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 1/17/24.
//

import SwiftUI

struct AddLetterView: View {
    @StateObject private var addLetterViewModel = AddLetterViewModel()
    
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

    init(isSendingLetter: Bool) {
        self.isSendingLetter = isSendingLetter

        // TextEditor 패딩
        UITextView.appearance().textContainerInset = UIEdgeInsets(top: 12, left: 8, bottom: 12, right: 8)
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
            .navigationTitle("편지 등록")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color(hex: 0xF5F1E8), for: .navigationBar)
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                        // 편지 저장하기
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
            .fullScreenCover(isPresented: $addLetterViewModel.showLetterImageFullScreenView) {
                LetterImageFullScreenView(images: addLetterViewModel.images, pageIndex: $addLetterViewModel.selectedIndex)
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
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(isSendingLetter ? "받는 사람" : "보낸 사람")
                    .font(.headline)

                TextField("", text: $addLetterViewModel.sender)
                    .textFieldStyle(.roundedBorder)
                    .focused($focusField, equals: .sender)
            }
            .frame(width: UIScreen.main.bounds.width / 3)

            Spacer()

            VStack(alignment: .leading, spacing: 4) {
                Text(isSendingLetter ? "보낸 날짜" : "받은 날짜")
                    .font(.headline)

                TextField("", text: .constant(dateFormatter.string(from: addLetterViewModel.date)))
                    .textFieldStyle(.roundedBorder)
                    .overlay {
                        DatePicker(
                            "",
                            selection: $addLetterViewModel.date,
                            displayedComponents: .date
                        )
                        .labelsHidden()
                        .environment(\.locale, Locale.init(identifier: "ko"))
                        .blendMode(.destinationOver)
                    }
            }
            .frame(width: UIScreen.main.bounds.width / 3)

            Spacer()
        }

    }

    @ViewBuilder
    private var letterImagesSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("편지 사진")
                .font(.headline)

            ScrollView(.horizontal) {
                HStack(spacing: 8) {
                    Button {
                        addLetterViewModel.showConfirmationDialog = true
                    } label: {
                        Image(systemName: "envelope.open.fill")
                            .padding()
                            .frame(width: 100, height: 100)
                            .background(
                                Color.white,
                                in: RoundedRectangle(cornerRadius: 5)
                            )
                    }

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

    @ViewBuilder
    private var letterTextSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("편지 내용")
                .font(.headline)

            TextEditor(text: $addLetterViewModel.text)
                .lineSpacing(5)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.black, lineWidth: 1 / 4)
                        .opacity(0.2)
                )
                .frame(maxWidth: .infinity)
                .frame(height: 350)
                .focused($focusField, equals: .text)
        }

        VStack(alignment: .leading, spacing: 4) {
            Text("한 줄 요약")
                .font(.headline)

            TextField("", text: $addLetterViewModel.receiver)
                .textFieldStyle(.roundedBorder)
                .focused($focusField, equals: .receiver)
        }
    }
}

#Preview {
    NavigationStack {
        AddLetterView(isSendingLetter: true)
    }
}
