//
//  ListLetterView.swift
//  PJ3T3_Postie
//
//  Created by 권운기 on 2/1/24.
//

import SwiftUI

struct ListLetterView: View {
    @ObservedObject var firestoreManager = FirestoreManager.shared
    @AppStorage("isThemeGroupButton") private var isThemeGroupButton: Int = 0
    @Binding var isMenuActive: Bool
    @State private var showAlert = false
    @State private var activeLink: String?
    
    var body: some View {
        ForEach(firestoreManager.letters.sorted(by: { $0.date < $1.date }), id: \.self) { letter in
            Button(action: {
                if letter.date > Date() && letter.writer == letter.recipient {
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
                    message: Text("도착하지 못한 편지는 열어 볼 수 없어요... 편지가 도착할 때까지 기다려 주세요!"),
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
        
    }
}

struct LetterItemView: View {
    @AppStorage("isThemeGroupButton") private var isThemeGroupButton: Int = 0
    
    var letter: Letter
    
    var body: some View {
        HStack {
            if !letter.isReceived {
                Spacer()
            }
            
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text(!letter.isReceived ? "To." : "From.")
                            .font(.custom("SourceSerifPro-Black", size: 18))
                            .foregroundColor(postieColors.tabBarTintColor)
                        
                        Text("\(letter.recipient)")
                            .foregroundColor(postieColors.tabBarTintColor)
                        
                        Spacer()
                        
                        Text("\(letter.date.toString())")
                            .font(.custom("SourceSerifPro-Light", size: 15))
                            .foregroundStyle(postieColors.tabBarTintColor)
                        
                        if postieColors.backGroundColor == .postieBlack {
                            Image(!letter.isReceived ? "sendWhite" : "takeWhite")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                        } else {
                            Image(!letter.isReceived ? "send" : "take")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                        }
//                        ZStack {
//                            Image(systemName: "water.waves")
//                                .font(.headline)
//                                .offset(x: 18)
//                            
//                            Image(systemName: "sleep.circle")
//                                .font(.largeTitle)
//                        }
//                        .foregroundStyle(postieColors.dividerColor)
                    }
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        if letter.recipient == letter.writer && Date() < letter.date {
                            Image(systemName: "lock")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 30)
                                .offset(y: -10)
                                .foregroundStyle(postieColors.tabBarTintColor)
                        } else if !letter.summary.isEmpty && letter.recipient != letter.writer && Date() < letter.date {
                            Text("“")
                                .font(.custom("SairaStencilOne-Regular", size: 30))
                                .foregroundStyle(postieColors.tabBarTintColor)
                            
                            Text(letter.summary)
                                .foregroundStyle(postieColors.tabBarTintColor)
                            
                            Text("”")
                                .font(.custom("SairaStencilOne-Regular", size: 30))
                                .foregroundStyle(postieColors.tabBarTintColor)
                        } else if !letter.summary.isEmpty && Date() > letter.date {
                            Text("“")
                                .font(.custom("SairaStencilOne-Regular", size: 30))
                                .foregroundStyle(postieColors.tabBarTintColor)
                            
                            Text(letter.summary)
                                .foregroundStyle(postieColors.tabBarTintColor)
                            
                            Text("”")
                                .font(.custom("SairaStencilOne-Regular", size: 30))
                                .foregroundStyle(postieColors.tabBarTintColor)
                        }
                        
                        Spacer()
                        
                        if letter.isFavorite {
                            Image(systemName: "heart.fill")
                                .font(.title2)
                                .foregroundStyle(Color.postieOrange)
                        }
                    }
                }
            }
            .padding()
            .frame(width: 300, height: 130)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .foregroundStyle(!letter.isReceived ? postieColors.writenLetterColor : postieColors.receivedLetterColor)
                    .shadow(color: Color.postieBlack.opacity(0.1), radius: 3, x: 3, y: 3)
            )
            
            if letter.isReceived {
                Spacer()
            }
        }
        .padding(.horizontal)
    }
}
//#Preview {
//    ListLetterView()
//}
