//
//  AddLetterView.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 1/17/24.
//

import SwiftUI

struct AddLetterView: View {
    @StateObject private var addLetterViewModel: AddLetterViewModel
    @ObservedObject var firestoreManager = FirestoreManager.shared
    @ObservedObject var storageManager = StorageManager.shared

    enum Field: Hashable {
        case sender
        case receiver
        case text
        case summary
    }

    var isReceived: Bool

    @FocusState private var focusField: Field?
    @Environment(\.dismiss) var dismiss
    @AppStorage("isThemeGroupButton") private var isThemeGroupButton: Int = 0

    init(isReceived: Bool) {
        self.isReceived = isReceived
        self._addLetterViewModel = StateObject(wrappedValue: AddLetterViewModel(isReceived: isReceived))

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
                Text(isReceived ? "받은 편지 기록" : "보낸 편지 기록")
                    .bold()
                    .foregroundStyle(ThemeManager.themeColors[isThemeGroupButton].tintColor)
            }

            ToolbarItemGroup(placement: .topBarTrailing) {
                Button {
                    Task {
                        await addLetterViewModel.uploadLetter()
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
        .customOnChange(addLetterViewModel.shouldDismiss) { shouldDismiss in
            if shouldDismiss {
                dismiss()
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .scrollDismissesKeyboard(.interactively)
        .fullScreenCover(isPresented: $addLetterViewModel.showingLetterImageFullScreenView) {
            LetterImageFullScreenView(
                images: addLetterViewModel.images,
                pageIndex: $addLetterViewModel.selectedIndex
            )
        }
        .sheet(isPresented: $addLetterViewModel.showingUIImagePicker) {
            UIImagePicker(
                sourceType: addLetterViewModel.imagePickerSourceType,
                selectedImages: $addLetterViewModel.images,
                text: $addLetterViewModel.text,
                showingTextRecognizerErrorAlert: $addLetterViewModel.showingTextRecognizerErrorAlert
            )
            .ignoresSafeArea(.all, edges: .bottom)
        }
        .alert("문자 인식 실패", isPresented: $addLetterViewModel.showingTextRecognizerErrorAlert) {

        } message: {
            Text("문자 인식에 실패했습니다. 다시 시도해 주세요.")
        }
        .alert("한 줄 요약", isPresented: $addLetterViewModel.showingSummaryAlert) {
            Button("직접 작성") {
                // TODO: 함수로 빼기
                addLetterViewModel.showSummaryTextField()
                focusField = .summary
            }

            Button("AI 완성") {
                // TODO: 네이버 클로바 API 호출
                addLetterViewModel.showSummaryTextField()
                focusField = .summary
            }
        }
        .alert("편지 정보 부족", isPresented: $addLetterViewModel.showingNotEnoughInfoAlert) {

        } message: {
            Text("편지를 저장하기 위한 정보가 부족해요. \(isReceived ? "보낸 사람" : "받는 사람")과 내용을 채워주세요.")
        }
        .alert("편지 저장 실패", isPresented: $addLetterViewModel.showingUploadErrorAlert) {

        } message: {
            Text("편지 저장에 실패했어요. 다시 시도해주세요.")
        }
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
                .background(ThemeManager.themeColors[isThemeGroupButton].receivedLetterColor)
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
                    .foregroundStyle(ThemeManager.themeColors[isThemeGroupButton].dividerColor)
                    .frame(maxWidth: .infinity)
                    .frame(height: 100)
                    .frame(alignment: .center)
            } else {
                ScrollView(.horizontal) {
                    HStack(spacing: 8) {
                        ForEach(0..<addLetterViewModel.images.count, id: \.self) { index in
                            ZStack(alignment: .topTrailing) {
                                Button {
                                    addLetterViewModel.showLetterImageFullScreenView(index: index)
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
                if addLetterViewModel.text.isEmpty {
                    TextEditor(text: .constant("사진을 등록하면 자동으로 편지 내용이 입력됩니다."))
                        .scrollContentBackground(.hidden)
                        .background(ThemeManager.themeColors[isThemeGroupButton].receivedLetterColor)
                        .lineSpacing(5)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                        .frame(maxWidth: .infinity)
                        .frame(height: 350)
                        .disabled(true)
                }

                TextEditor(text: $addLetterViewModel.text)
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
                    .opacity(addLetterViewModel.text.isEmpty ? 0.25 : 1)
                    .focused($focusField, equals: .text)
            }
        }

        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("한 줄 요약")

                Spacer()

                Button {
                    addLetterViewModel.showSummaryAlert()
                } label: {
                    Image(systemName: "plus")
                }
            }

            if addLetterViewModel.showingSummaryTextField || !addLetterViewModel.summary.isEmpty {
                TextField("", text: $addLetterViewModel.summary)
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
    NavigationStack {
        AddLetterView(isReceived: false)
    }
}
