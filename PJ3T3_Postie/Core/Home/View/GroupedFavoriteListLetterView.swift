//
//  GroupedFavoriteListLetter.swift
//  PJ3T3_Postie
//
//  Created by 권운기 on 2/1/24.
//

import SwiftUI

struct GroupedFavoriteListLetterView: View {
    @ObservedObject var firestoreManager = FirestoreManager.shared
    @ObservedObject var storageManager = StorageManager.shared
    
    @State private var isSideMenuOpen: Bool = false
    @Binding var isThemeGroupButton: Int
    
    var body: some View {
        let postieColors = ThemeManager.themeColors[isThemeGroupButton]
        
        ZStack(alignment: .bottomTrailing) {
            postieColors.backGroundColor
                .ignoresSafeArea()
            
            ScrollView {
                ForEach(firestoreManager.letters, id: \.self) { letter in
                    NavigationLink {
                        LetterDetailView(letter: letter)
                    } label: {
                        favoriteLetterView(letter: letter)
                    }
                }
                
                // ScrollView margin 임시
                Rectangle()
                    .frame(height: 80)
                    .foregroundStyle(Color.postieBlack.opacity(0))
            }
            
            AddLetterButton(isThemeGroupButton: $isThemeGroupButton)
        }
        .tint(postieColors.tabBarTintColor)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("좋아하는 편지들")
                    .bold()
                    .foregroundStyle(postieColors.tintColor)
            }
        }
    }
    
    @ViewBuilder
    private func favoriteLetterView(letter: Letter) -> some View {
        if letter.isFavorite {
            LetterItemView(letter: letter, isThemeGroupButton: $isThemeGroupButton)
        } else {
            EmptyView()
        }
    }
}

//#Preview {
//    GroupedFavoriteListLetter()
//}
