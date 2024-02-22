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
            
            if filteredMyLetters.count == 0 {
                HStack {
                    Spacer()
                    
                    VStack {
                        Spacer()
                        
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
                        
                        Spacer()
                    }
                    .padding()
                    
                    Spacer()
                }
            }
            
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
                            title: Text("알림"),
                            message: Text("아직 도착하지 못한 편지라 열어 볼 수 없습니다. 지정된 날짜 까지 기다려 주세요!"),
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
