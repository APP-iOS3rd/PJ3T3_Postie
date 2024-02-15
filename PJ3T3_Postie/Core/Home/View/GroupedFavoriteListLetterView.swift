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
    
    var body: some View {
        let favoriteLetters = firestoreManager.letters.filter { $0.isFavorite }
        
        ZStack(alignment: .bottomTrailing) {
            postieColors.backGroundColor
                .ignoresSafeArea()
            
            if firestoreManager.letters.isEmpty {
                VStack {
                    Image("postyHeartSketch")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300)
                        .opacity(0.5)
                    
                    Text("\n좋아하는 편지가 없어요 ㅠ.ㅠ 저장한 편지에서 하트를 눌러보세요!")
                        .font(.callout)
                        .foregroundStyle(postieColors.dividerColor)
                }
                .offset(x: -30, y: -150)
                .padding()
            }
                
            ScrollView {
                ForEach(favoriteLetters, id: \.self) { letter in
                    NavigationLink {
                        LetterDetailView(letter: letter)
                    } label: {
                        LetterItemView(letter: letter)
                    }
                }
                
                // ScrollView margin 임시
                Rectangle()
                    .frame(height: 80)
                    .foregroundStyle(Color.postieBlack.opacity(0))
            }
            
            AddLetterButton()
        }
        .toolbarBackground(postieColors.backGroundColor, for: .navigationBar)
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
}

//#Preview {
//    GroupedFavoriteListLetter()
//}
