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
    @AppStorage("isThemeGroupButton") private var isThemeGroupButton: Int = 0
    @State private var isMenuActive = false
    @State private var isSideMenuOpen: Bool = false
    
    var body: some View {
        let favoriteLetters = firestoreManager.letters.filter { $0.isFavorite }.sorted { $0.date < $1.date }
        
        ZStack(alignment: .bottomTrailing) {
            postieColors.backGroundColor
                .ignoresSafeArea()
            
            if favoriteLetters.count == 0 {
                HStack {
                    Spacer()
                    
                    VStack {
                        Spacer()
                        
                    Image(isThemeGroupButton == 4 ? "postyHeartSketchWhite" : "postyHeartSketch")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300)
                        .opacity(0.5)
                        .padding(.bottom)
                    
                    Text("좋아하는 편지가 없어요 ㅠ.ㅠ")
                        .font(.headline)
                        .foregroundStyle(postieColors.tintColor)
                    
                    Text("저장한 편지에서 하트를 눌러보세요!")
                        .foregroundStyle(postieColors.dividerColor)
                        
                        Spacer()
                    }
                    .padding()
                    
                    Spacer()
                }
            }
                
            ScrollView {
                ForEach(favoriteLetters, id: \.self) { letter in
                    NavigationLink {
                        LetterDetailView(letter: letter)
                    } label: {
                        LetterItemView(letter: letter)
                    }
                    .disabled(isMenuActive)
                }
                
                // ScrollView margin 임시
                Rectangle()
                    .frame(height: 80)
                    .foregroundStyle(Color.postieBlack.opacity(0))
            }
            
            AddLetterButton(isMenuActive: $isMenuActive)
        }
        .onTapGesture {
            if self.isMenuActive {
                self.isMenuActive = false
            }
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
