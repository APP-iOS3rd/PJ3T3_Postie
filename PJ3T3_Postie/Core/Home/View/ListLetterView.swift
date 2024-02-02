//
//  ListLetterView.swift
//  PJ3T3_Postie
//
//  Created by 권운기 on 2/1/24.
//

import SwiftUI

struct ListLetterView: View {
    @ObservedObject var firestoreManager = FirestoreManager.shared
    
    var body: some View {
        ForEach(firestoreManager.letters, id: \.self) { letter in
            NavigationLink {
                LetterDetailView(letter: letter)
            } label: {
                LetterItemView(letter: letter)
            }
        }
    }
}

struct LetterItemView: View {
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
                            .foregroundColor(Color.postieBlack)
                        
                        Text("\(letter.recipient)")
                        
                        Spacer()
                        
                        Text("\(letter.date.toString())")
                            .font(.custom("SourceSerifPro-Light", size: 18))
                            .foregroundStyle(Color.postieBlack)
                        
                        ZStack {
                            Image(systemName: "water.waves")
                                .font(.headline)
                                .offset(x:18)
                            
                            Image(systemName: "sleep.circle")
                                .font(.largeTitle)
                        }
                        .foregroundStyle(Color.postieDarkGray)
                    }
                    
                    Spacer()
                    
                    HStack {
                        Text("\"\(letter.summary)\"")
                        
                        Spacer()
                        
                        Image(systemName: "heart.fill")
                            .font(.title2)
                            .foregroundStyle(Color.postieOrange)
                    }
                }
            }
            .padding()
            .frame(width: 300, height: 130)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(letter.isReceived ? Color.postieLightGray : Color.postieWhite)
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
