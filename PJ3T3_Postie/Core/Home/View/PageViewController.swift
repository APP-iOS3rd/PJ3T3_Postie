//
//  PageViewController.swift
//  PJ3T3_Postie
//
//  Created by KHJ on 2024/01/18.
//

import SwiftUI

struct Page: View {
    @Binding var letter: Letter
    @AppStorage("isThemeGroupButton") private var isThemeGroupButton: Int = 0

    var body: some View {
        ScrollView {
            HStack {
                Text("To. ")
                    .font(.view(.sourceSerifProBlack))
                + Text(letter.recipient)
                    .font(.letter(.nanumMyeongjoBold))
                Spacer()
            }

            Text(letter.text)
                .font(.letter(.nanumMyeongjo))
                .lineSpacing(10.0)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity, alignment: .leading)

            Spacer()

            HStack {
                Text(letter.date.toString(format: "yyyy년 M월 d일"))
                    .font(.letter(.nanumMyeongjo))

                Spacer()

                Text("From. ")
                    .font(.view(.sourceSerifProBlack))
                + Text(letter.writer)
                    .font(.letter(.nanumMyeongjoBold))
            }
        }
        .scrollIndicators(.never)
        .padding()
        .background(ThemeManager.themeColors[isThemeGroupButton].receivedLetterColor)
        .clipShape(RoundedRectangle(cornerRadius: 4))
    }
}

#Preview {
    NavigationStack {
        LetterDetailView(letter: Letter.preview)
    }
}
