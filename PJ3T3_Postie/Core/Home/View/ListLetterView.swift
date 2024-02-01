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
                HStack {
                    if letter.isReceived {
                        Spacer()
                    }
                    
                    HStack {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("To.")
                                    .font(.custom("SourceSerifPro-Black", size: 18))
                                    .foregroundColor(.black)
                                
                                Text("\(letter.recipient)")
                                
                                Spacer()
                                
                                Text("\(letter.date.toString())")
                                    .font(.custom("SourceSerifPro-Light", size: 18))
                                    .foregroundStyle(Color(hex: 0x1E1E1E))
                                
                                ZStack {
                                    Image(systemName: "water.waves")
                                        .font(.headline)
                                        .offset(x:18)
                                    
                                    Image(systemName: "sleep.circle")
                                        .font(.largeTitle)
                                }
                                .foregroundStyle(Color(hex: 0x979797))
                            }
                            
                            Spacer()
                            
                            Text("\"\(letter.summary)\"")
                        }
                    }
                    .padding()
                    .frame(width: 300, height: 130)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(letter.isReceived ? Color(hex: 0xF7F7F7) : Color(hex: 0xFCFBF7))
                            .shadow(color: Color.black.opacity(0.1), radius: 3, x: 3, y: 3)
                    )
                    
                    if !letter.isReceived {
                        Spacer()
                    }
                }
            }
        }
    }
}

//#Preview {
//    ListLetterView()
//}
