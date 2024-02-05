//
//  GroupedFavoriteListLetter.swift
//  PJ3T3_Postie
//
//  Created by 권운기 on 2/1/24.
//

import SwiftUI

struct GroupedFavoriteListLetter: View {
    @ObservedObject var firestoreManager = FirestoreManager.shared
    @ObservedObject var storageManager = StorageManager.shared
    @State private var showAlert: Bool = false
    @State private var isSideMenuOpen: Bool = false
    @Binding var isThemeGroupButton: Int
    
    @ViewBuilder
    func FavoriteLetterView(letter: Letter) -> some View {
        if letter.isFavorite {
            LetterItemView(isThemeGroupButton: $isThemeGroupButton, letter: letter)
        } else {
            EmptyView()
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ThemeManager.themeColors[isThemeGroupButton].backGroundColor
                .ignoresSafeArea()
            
            ScrollView {
                ForEach(firestoreManager.letters, id: \.self) { letter in
                    NavigationLink {
                        LetterDetailView(letter: letter)
                    } label: {
                        FavoriteLetterView(letter: letter)
                    }
                }
                
                // ScrollView margin 임시
                Rectangle()
                    .frame(height: 80)
                    .foregroundStyle(Color.postieBlack.opacity(0))
            }
            
            AddLetterButton(isThemeGroupButton: $isThemeGroupButton)
        }
        .tint(ThemeManager.themeColors[isThemeGroupButton].tabBarTintColor)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("좋아하는 편지들")
                    .bold()
                    .foregroundStyle(ThemeManager.themeColors[isThemeGroupButton].tintColor)
            }
        }
    }
}

//#Preview {
//    GroupedFavoriteListLetter()
//}
