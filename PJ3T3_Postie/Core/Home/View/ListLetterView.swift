//
//  ListLetterView.swift
//  PJ3T3_Postie
//
//  Created by 권운기 on 2/1/24.
//

import SwiftUI

struct ListLetterView: View {
    @ObservedObject var firestoreManager = FirestoreManager.shared
    @Binding var currentColorPage: Int
    
    var body: some View {
        ForEach(firestoreManager.letters, id: \.self) { letter in
            NavigationLink {
                LetterDetailView(letter: letter)
            } label: {
                LetterItemView(currentColorPage: $currentColorPage, letter: letter)
            }
        }
    }
}

struct LetterItemView: View {
    @Binding var currentColorPage: Int
    var letter: Letter
    
    var body: some View {
        HStack {
            if letter.isReceived {
                Spacer()
            }
            
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text(letter.isReceived ? "To." : "From.")
                            .font(.custom("SourceSerifPro-Black", size: 18))
                            .foregroundColor(ThemeManager.themeColors[currentColorPage].tabBarTintColor)
                        
                        Text("\(letter.recipient)")
                            .foregroundColor(ThemeManager.themeColors[currentColorPage].tabBarTintColor)
                        
                        Spacer()
                        
                        Text("\(letter.date.toString())")
                            .font(.custom("SourceSerifPro-Light", size: 18))
                            .foregroundStyle(ThemeManager.themeColors[currentColorPage].tabBarTintColor)
                        
                        ZStack {
                            Image(systemName: "water.waves")
                                .font(.headline)
                                .offset(x:18)
                            
                            Image(systemName: "sleep.circle")
                                .font(.largeTitle)
                        }
                        .foregroundStyle(ThemeManager.themeColors[currentColorPage].dividerColor)
                    }
                    
                    Spacer()
                    
                    HStack {
                        Text("\"\(letter.summary)\"")
                            .foregroundColor(ThemeManager.themeColors[currentColorPage].tabBarTintColor)
                        
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
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(letter.isReceived ? ThemeManager.themeColors[currentColorPage].writenLetterColor : ThemeManager.themeColors[currentColorPage].receivedLetterColor)
                    .shadow(color: Color.postieBlack.opacity(0.1), radius: 3, x: 3, y: 3)
            )
            
            if !letter.isReceived {
                Spacer()
            }
        }
        .padding(.horizontal)
    }
}
//#Preview {
//    ListLetterView()
//}
