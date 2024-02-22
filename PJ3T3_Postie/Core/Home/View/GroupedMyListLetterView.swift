//
//  GroupedMyListLetterView.swift
//  PJ3T3_Postie
//
//  Created by 권운기 on 2/22/24.
//

import SwiftUI

struct GroupedMyListLetterView: View {
    @ObservedObject var firestoreManager = FirestoreManager.shared
    @ObservedObject var storageManager = StorageManager.shared
    @AppStorage("isThemeGroupButton") private var isThemeGroupButton: Int = 0
    @State private var isMenuActive = false
    @State private var isSideMenuOpen: Bool = false
    
    var body: some View {
        let filteredLetters = firestoreManager.letters.filter { $0.recipient == $0.writer}.sorted { $0.date < $1.date }
        
        ZStack(alignment: .bottomTrailing) {
            postieColors.backGroundColor
                .ignoresSafeArea()
            
            if filteredLetters.count == 0 {
                VStack {
                    Image(isThemeGroupButton == 4 ? "postySmileSketchWhite" : "postySmileSketch")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300)
                        .opacity(0.5)
                        .padding(.bottom)
                    
                    Text("나와 주고받은 편지가 없어요..")
                        .font(.headline)
                        .foregroundStyle(postieColors.tintColor)
                    
                    Text("나의 느린 우체통 기능을 사용해보세요!")
                        .foregroundStyle(postieColors.dividerColor)
                }
                .offset(x: -30, y: -150)
                .padding()
            }
                
            ScrollView {
                ForEach(filteredLetters, id: \.self) { letter in
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

#Preview {
    GroupedMyListLetterView()
}
