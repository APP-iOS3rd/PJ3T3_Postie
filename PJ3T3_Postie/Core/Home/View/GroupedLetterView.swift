//
//  GroupedLetterView.swift
//  PJ3T3_Postie
//
//  Created by 권운기 on 2/1/24.
//

import SwiftUI

struct GroupedLetterView: View {
    @ObservedObject var firestoreManager = FirestoreManager.shared
    @ObservedObject var authManager = AuthManager.shared
    @StateObject private var grouedLetterViewModel = GroupedLetterViewModel()
    @AppStorage("isThemeGroupButton") private var isThemeGroupButton: Int = 0
    
    var letterReceivedGrouped: [String] = []
    var letterWritedGrouped: [String] = []
    var letterGrouped: [String] = []
    var homeWidth: CGFloat

    // 편지 데이터 정렬
    func sortedLetterData() -> [String] {
        // recipient 에서 중복 된것을 제외 후 letterReceivedGrouped 에 삽입
        let letterReceivedGrouped: [String] = Array(Set(firestoreManager.letters.map { $0.recipient }.filter { !$0.isEmpty }))
        // writer 에서 중복 된것을 제외 후 letterWritedGrouped 에 삽입
        let letterWritedGrouped: [String] = Array(Set(firestoreManager.letters.map { $0.writer }.filter { !$0.isEmpty }))
        // letterReceivedGrouped와 letterWritedGrouped를 합친 후 중복 제거
        let letterGrouped: [String] = Array(Set(letterReceivedGrouped + letterWritedGrouped))
        // 본인 이름 항목 제거
        let filteredLetterGrouped: [String] = letterGrouped.filter { $0 != authManager.currentUser?.nickname }
        // 숫자, 한글, 알파벳 순서대로 정렬
        let sortedRecipients = grouedLetterViewModel.customSort(recipients: filteredLetterGrouped)
        
        return sortedRecipients
    }
    
    var body: some View {
        // 편지 데이터 정렬
        let sortedRecipients = sortedLetterData()
        // 좋아하는 편지들만 필터
        let favoriteLetters = firestoreManager.letters.filter { $0.isFavorite }
        
        VStack {
            NavigationLink { // 좋아하는 편지 뷰
                GroupedFavoriteListLetterView()
            } label: {
                HStack {
                    VStack {
                        HStack {
                            Text("My Favorite.")
                                .font(.custom("SourceSerifPro-Black", size: 18))
                                .foregroundColor(postieColors.tabBarTintColor)
                            
                            Text("\("좋아하는 편지 ")")
                                .foregroundStyle(postieColors.tabBarTintColor)
                            
                            Spacer()
                            
                            Text(" ") // date
                                .font(.custom("SourceSerifPro-Light", size: 18))
                                .foregroundStyle(postieColors.tabBarTintColor)
                            
                            ZStack {
                                Image(systemName: "water.waves")
                                    .font(.headline)
                                    .offset(x:18)
                                
                                Image(systemName: "sleep.circle")
                                    .font(.largeTitle)
                            }
                            .foregroundStyle(postieColors.dividerColor)
                        }
                        
                        Spacer()
                        
                        ZStack {
                            HStack {
                                Spacer()
                                
                                Text("\"")
                                    .font(.custom("SourceSerifPro-Black", size: 17))
                                
                                Text("좋아하는 편지 꾸러미")
                                    .foregroundStyle(postieColors.tabBarTintColor)
                                
                                Text("\"")
                                    .font(.custom("SourceSerifPro-Black", size: 17))
                                
                                Spacer()
                            }
                            
                            HStack {
                                Spacer()
                                
                                Image(systemName: "heart.fill")
                                    .font(.title2)
                                    .foregroundStyle(Color.postieOrange)
                            }
                        }
                    }
                    .padding()
                    .frame(width:homeWidth * 0.9, height: 130)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .foregroundStyle(postieColors.receivedLetterColor)
                            .shadow(color: .black.opacity(0.1), radius: 3, x: 3, y: 3)
                    )
                    .modifier(StackedRoundedRectangleModifier(count: favoriteLetters.count, groupWidth: homeWidth))
                }
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
            
            // 편지 그룹 뷰
            ForEach(sortedRecipients, id: \.self) { recipient in
                // 받거나 보낸 사람 수 확인
                let countOfMatchingRecipients = firestoreManager.letters.filter { $0.recipient == recipient }.count
                let countOfMatchingWriters = firestoreManager.letters.filter { $0.writer == recipient }.count
                
                NavigationLink {
                    GroupedListLetterView(recipient: recipient)
                } label: {
                    HStack {
                        ZStack {
                            VStack {
                                HStack {
                                    Text("With.")
                                        .font(.custom("SourceSerifPro-Black", size: 18))
                                        .foregroundColor(postieColors.tabBarTintColor)
                                    
                                    Text("\(recipient)")
                                        .foregroundColor(postieColors.tabBarTintColor)
                                    
                                    Spacer()
                                    
                                    Text(" ") // date
                                        .font(.custom("SourceSerifPro-Light", size: 18))
                                        .foregroundStyle(postieColors.tabBarTintColor)
                                    
                                    ZStack {
                                        Image(systemName: "water.waves")
                                            .font(.headline)
                                            .offset(x:18)
                                        
                                        Image(systemName: "sleep.circle")
                                            .font(.largeTitle)
                                    }
                                    .foregroundStyle(postieColors.dividerColor)
                                }
                                
                                Spacer()
                                
                                HStack {
                                    Spacer()
                                    
                                    Text("\"")
                                        .font(.custom("SourceSerifPro-Black", size: 17))
                                    
                                    Text("\(recipient)님과 주고받은 편지 꾸러미")
                                    
                                    Text("\"")
                                        .font(.custom("SourceSerifPro-Black", size: 17))
                                    
                                    Spacer()
                                }
                            }
                            .padding()
                            .frame(width: homeWidth * 0.9, height: 130)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .foregroundStyle(postieColors.receivedLetterColor)
                                    .shadow(color: .black.opacity(0.1), radius: 3, x: 3, y: 3)
                            )
                            .modifier(StackedRoundedRectangleModifier(count: countOfMatchingRecipients + countOfMatchingWriters, groupWidth: homeWidth))
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 8)
                        
                        Spacer()
                    }
                }
            }
        }
        .toolbarBackground(postieColors.backGroundColor, for: .navigationBar)
        .tint(postieColors.tabBarTintColor)
    }
}

struct StackedRoundedRectangleModifier: ViewModifier {
    @AppStorage("isThemeGroupButton") private var isThemeGroupButton: Int = 0
    
    let count: Int
    var groupWidth: CGFloat
    
    func body(content: Content) -> some View {
        ZStack {
            if count > 2 {
                RoundedRectangle(cornerRadius: 4)
                    .foregroundStyle(postieColors.receivedLetterColor)
                    .frame(width: groupWidth * 0.9, height: 130)
                    .offset(x: 10, y: 10)
                    .shadow(color: .black.opacity(0.1), radius: 3, x: 3, y: 3)
            }
            
            if count > 1 {
                RoundedRectangle(cornerRadius: 4)
                    .foregroundStyle(postieColors.receivedLetterColor)
                    .frame(width: groupWidth * 0.9, height: 130)
                    .offset(x: 5, y: 5)
                    .shadow(color: .black.opacity(0.1), radius: 3, x: 3, y: 3)
            }
            
            content
        }
    }
}

//#Preview {
//    GroupedLetterView()
//}
