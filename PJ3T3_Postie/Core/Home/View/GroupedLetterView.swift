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
    @Binding var isThemeGroupButton: Int
    var letterReceivedGrouped: [String] = []
    var letterWritedGrouped: [String] = []
    var letterGrouped: [String] = []
    
    // 숫자, 한글, 알파벳 순서대로 정렬
    func customSort(recipients: [String]) -> [String] {
        return recipients.sorted { (lhs: String, rhs: String) -> Bool in
            func isKorean(_ string: String) -> Bool {
                for scalar in string.unicodeScalars {
                    if CharacterSet(charactersIn: "가"..."힣").contains(scalar) {
                        return true
                    }
                }
                return false
            }
            
            func isNumber(_ string: String) -> Bool {
                return string.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil
            }
            
            let lhsPriority = (isNumber(lhs) ? 0 : isKorean(lhs) ? 1 : 2)
            let rhsPriority = (isNumber(rhs) ? 0 : isKorean(rhs) ? 1 : 2)
            
            // 왼쪽 String과 오른쪽 String을 비교하여 숫자, 한글, 알파벳 순으로 정렬
            return lhsPriority == rhsPriority ? lhs < rhs : lhsPriority < rhsPriority
        }
    }
    
    // 편지 데이터 정렬
    func sortedLetterData() -> [String] {
        // recipient 에서 중복 된것을 제외 후 letterReceivedGrouped 에 삽입
        let letterReceivedGrouped: [String] = Array(Set(firestoreManager.letters.map { $0.recipient }.filter { !$0.isEmpty }))
        // writer 에서 중복 된것을 제외 후 letterWritedGrouped 에 삽입
        let letterWritedGrouped: [String] = Array(Set(firestoreManager.letters.map { $0.writer }.filter { !$0.isEmpty }))
        // letterReceivedGrouped와 letterWritedGrouped를 합친 후 중복 제거
        let letterGrouped: [String] = Array(Set(letterReceivedGrouped + letterWritedGrouped))
        // 본인 이름 항목 제거
        // "me" << 추후에는 authManager.currentUser?.nickName 로 해야함
        let filteredLetterGrouped: [String] = letterGrouped.filter { $0 != "me" }
        // 숫자, 한글, 알파벳 순서대로 정렬
        let sortedRecipients = customSort(recipients: filteredLetterGrouped)
        
        return sortedRecipients
    }
    
    var body: some View {
        let postieColors = ThemeManager.themeColors[isThemeGroupButton]
        // 편지 데이터 정렬
        let sortedRecipients = sortedLetterData()
        // 좋아하는 편지들만 필터
        let favoriteLetters = firestoreManager.letters.filter { $0.isFavorite }
        
        VStack {
            NavigationLink { // 좋아하는 편지 뷰
                GroupedFavoriteListLetter(isThemeGroupButton: $isThemeGroupButton)
            } label: {
                HStack {
                    ZStack {
                        if favoriteLetters.count > 2 {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(postieColors.receivedLetterColor)
                                .frame(width: 350, height: 130)
                                .offset(x: 10, y: 10)
                                .shadow(color: Color.black.opacity(0.1), radius: 3, x: 3, y: 3)
                        }
                        
                        if favoriteLetters.count > 1 {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(postieColors.receivedLetterColor)
                                .frame(width: 350, height: 130)
                                .offset(x: 5, y: 5)
                                .shadow(color: Color.black.opacity(0.1), radius: 3, x: 3, y: 3)
                        }
                        
                        HStack {
                            VStack(alignment: .leading) {
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
                                
                                HStack {
                                    Text("\"좋아하는 편지 꾸러미\"")
                                        .foregroundStyle(postieColors.tabBarTintColor)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "heart.fill")
                                        .font(.title2)
                                        .foregroundStyle(Color.postieOrange)
                                }
                            }
                            .padding()
                            .frame(width: 350, height: 130)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundStyle(postieColors.receivedLetterColor)
                                    .shadow(color: Color.postieBlack.opacity(0.1), radius: 3, x: 3, y: 3)
                            )
                        }
                    }
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
                    GroupedListLetterView(recipient: recipient, isThemeGroupButton: $isThemeGroupButton)
                } label: {
                    HStack {
                        ZStack {
                            if countOfMatchingRecipients + countOfMatchingWriters > 2 {
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundStyle(postieColors.receivedLetterColor)
                                    .frame(width: 350, height: 130)
                                    .offset(x: 10, y: 10)
                                    .shadow(color: Color.postieBlack.opacity(0.1), radius: 3, x: 3, y: 3)
                            }
                            
                            if countOfMatchingRecipients + countOfMatchingWriters > 1 {
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundStyle(postieColors.receivedLetterColor)
                                    .frame(width: 350, height: 130)
                                    .offset(x: 5, y: 5)
                                    .shadow(color: Color.postieBlack.opacity(0.1), radius: 3, x: 3, y: 3)
                            }
                            
                            HStack {
                                VStack(alignment: .leading) {
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
                                    
                                    Text("\"\(recipient)님과 주고받은 편지 꾸러미\"")
                                }
                            }
                            .padding()
                            .frame(width: 350, height: 130)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundStyle(postieColors.receivedLetterColor)
                                    .shadow(color: Color.black.opacity(0.1), radius: 3, x: 3, y: 3)
                            )
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 8)
                        
                        Spacer()
                    }
                }
            }
        }
        .tint(postieColors.tabBarTintColor)
    }
}

//#Preview {
//    GroupedLetterView()
//}
