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
    
    var body: some View {
        ForEach(firestoreManager.letters, id: \.self) { letter in
            NavigationLink {
                LetterDetailView(letter: letter)
            } label: {
                LetterItemView(letter: letter)
            }
            .disabled(isMenuActive)
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
                        
                        ZStack {
                            Image(systemName: "water.waves")
                                .font(.headline)
                                .offset(x: 18)
                            
                            Image(systemName: "sleep.circle")
                                .font(.largeTitle)
                        }
                        .foregroundStyle(postieColors.dividerColor)
                    }
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        if !letter.summary.isEmpty {
                            Text("“")
                                .font(.custom("SairaStencilOne-Regular", size: 30))
                            
                            Text(letter.summary)
                                .foregroundStyle(postieColors.tabBarTintColor)
                            
                            Text("”")
                                .font(.custom("SairaStencilOne-Regular", size: 30))
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
