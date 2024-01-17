//
//  AddLetterView.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 1/17/24.
//

import SwiftUI

struct AddLetterView: View {
    @StateObject private var addLetterViewModel = AddLetterViewModel()

    var body: some View {
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

                    Text("받는 사람")

                    TextField("", text: $addLetterViewModel.sender)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(hex: 0x807E79), lineWidth: 1)
                        )

                    Text("편지 날짜")

                    DatePicker("날짜", selection: $addLetterViewModel.date, displayedComponents: .date)
                        .labelsHidden()
                        .environment(\.locale, Locale.init(identifier: "ko"))

                    Text("편지 사진")

                    ScrollView(.horizontal) {
                        HStack(spacing: 8) {
                            Button {
                                // showConfirmationDialog
                            } label: {
                                Image(systemName: "envelope.open.fill")
                                    .padding()
                                    .frame(width: 100, height: 100)
                                    .background(
                                        Color.gray.opacity(0.2),
                                        in: RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    )
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
        }
    }
}

#Preview {
    NavigationStack {
        AddLetterView()
    }
}
