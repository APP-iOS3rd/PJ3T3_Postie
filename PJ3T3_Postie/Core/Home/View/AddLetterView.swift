//
//  AddLetterView.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 1/17/24.
//

import SwiftUI

struct AddLetterView: View {

    enum Field: Hashable {
        case sender
        case receiver
        case text
    }

    @StateObject private var addLetterViewModel = AddLetterViewModel()

    @FocusState private var focusField: Field?

    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: 0xF5F1E8)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading) {
                        Text("보내는 사람")

                        TextField("", text: $addLetterViewModel.sender)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(hex: 0x807E79), lineWidth: 1)
                            )
                            .focused($focusField, equals: .sender)

                        Text("받는 사람")

                        TextField("", text: $addLetterViewModel.receiver)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(hex: 0x807E79), lineWidth: 1)
                            )
                            .focused($focusField, equals: .receiver)

                        Text("편지 날짜")

                        DatePicker("날짜", selection: $addLetterViewModel.date, displayedComponents: .date)
                            .labelsHidden()
                            .environment(\.locale, Locale.init(identifier: "ko"))

                        Text("편지 사진")

                        ScrollView(.horizontal) {
                            HStack(spacing: 8) {
                                Button {
                                    addLetterViewModel.showConfirmationDialog = true
                                } label: {
                                    Image(systemName: "envelope.open.fill")
                                        .padding()
                                        .frame(width: 100, height: 100)
                                        .background(
                                            Color.gray.opacity(0.2),
                                            in: RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        )
                                }

                                ForEach(0..<addLetterViewModel.images.count, id: \.self) { index in
                                    ZStack {
                                        Button {
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

                        Text("편지 내용")

                        TextEditor(text: $addLetterViewModel.text)
                            .scrollContentBackground(.hidden)
                            .padding()
                            .lineSpacing(5)
                            .frame(maxWidth: .infinity)
                            .frame(height: 280)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(hex: 0x807E79), lineWidth: 1)
                            )
                            .focused($focusField, equals: .text)
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
                LetterImageFullScreenView(images: addLetterViewModel.images)
            }
            .sheet(isPresented: $addLetterViewModel.showUIImagePicker, content: {
                UIImagePicker(sourceType: addLetterViewModel.imagePickerSourceType, selectedImages: $addLetterViewModel.images, text: $addLetterViewModel.text)
            })
            .confirmationDialog("편지 사진 가져오기", isPresented: $addLetterViewModel.showConfirmationDialog) {
                Button("카메라") {
                    addLetterViewModel.imagePickerSourceType = .camera
                    addLetterViewModel.showUIImagePicker = true
                }

                Button("앨범") {
                    addLetterViewModel.imagePickerSourceType = .photoLibrary
                    addLetterViewModel.showUIImagePicker = true
                }

                Button("스캐너") {

                }
            } message: {
                Text("편지 사진 가져오기")
            }
        }
    }
}

#Preview {
    NavigationStack {
        AddLetterView()
    }
}
