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
    @State private var showAlert = false
    @State private var activeLink: String?
    
    var body: some View {
        let filteredMyLetters = firestoreManager.letters.filter { $0.recipient == $0.writer}.sorted { $0.date < $1.date }
        
        ZStack(alignment: .bottomTrailing) {
            postieColors.backGroundColor
                .ignoresSafeArea()
            
            ScrollView {
                ForEach(filteredMyLetters, id: \.self) { letter in
                    Button(action: {
                        if letter.date > Date() {
                            self.showAlert = true
                        } else {
                            self.activeLink = letter.id
                        }
                    }) {
                        LetterItemView(letter: letter)
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("아직 편지가 배송중이에요!"),
                            message: Text("도착하지 못한 편지는 열어 볼 수 없어요 \n 편지가 도착할 때까지 기다려 주세요!"),
                            dismissButton: .default(Text("확인"))
                        )
                    }
                    .background(
                        NavigationLink(destination: LetterDetailView(letter: letter), tag: letter.id, selection: $activeLink) {
                            EmptyView()
                        }
                            .hidden()
                    )
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
                Text("나의 느린 우체통")
                    .bold()
                    .foregroundStyle(postieColors.tintColor)
            }
        }
    }
}

#Preview {
    GroupedMyListLetterView()
}
