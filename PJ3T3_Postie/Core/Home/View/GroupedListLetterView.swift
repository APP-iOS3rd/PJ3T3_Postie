//
//  GroupedListLetterView.swift
//  PJ3T3_Postie
//
//  Created by 권운기 on 2/1/24.
//

import SwiftUI

struct GroupedListLetterView: View {
    @State private var showAlert = false
    @State private var isSideMenuOpen = false
    @ObservedObject var firestoreManager = FirestoreManager.shared
    @ObservedObject var storageManager = StorageManager.shared
    var recipient: String
    
    var body: some View {
        ZStack {
            Color.postieBeige
                .ignoresSafeArea()
            
            NavigationStack {
                ZStack(alignment: .bottomTrailing) {
                    ScrollView {
                        ForEach(firestoreManager.letters, id: \.self) { letter in
                            NavigationLink {
                                LetterDetailView(letter: letter)
                            } label: {
                                if letter.recipient == recipient || letter.writer == recipient {
                                    HStack {
                                        if letter.isReceived {
                                            Spacer()
                                        }
                                        
                                        HStack {
                                            VStack(alignment: .leading) {
                                                HStack {
                                                    if letter.isReceived {
                                                        Text("To.")
                                                            .font(.custom("SourceSerifPro-Black", size: 18))
                                                            .foregroundStyle(Color.postieBlack)
                                                    } else {
                                                        Text("From.")
                                                            .font(.custom("SourceSerifPro-Black", size: 18))
                                                            .foregroundStyle(Color.postieBlack)
                                                    }
                                                    
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
                                                
                                                Text("\"\(letter.summary)\"")
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
                                    .padding(5)
                                }
                            }
                        }
                        
                        // ScrollView margin 임시
                        Rectangle()
                            .frame(height: 70)
                            .foregroundStyle(Color.postieBlack.opacity(0))
                    }
                    .background(Color.postieWhite)
                    
                    Menu {
                        NavigationLink(destination: AddLetterView(isReceived: true)) {
                            Button (action: {
                            }) {
                                HStack {
                                    Text("나의 느린 우체통")
                                    
                                    Image(systemName: "envelope.open.badge.clock")
                                }
                            }
                        }
                        
                        NavigationLink(destination: AddLetterView(isReceived: false)) {
                            Button (action: {
                            }) {
                                HStack {
                                    Text("받은 편지 저장")
                                    
                                    Image(systemName: "envelope.open")
                                }
                            }
                        }
                        
                        NavigationLink(destination: AddLetterView(isReceived: true)) {
                            Button (action: {
                            }) {
                                HStack {
                                    Text("보낸 편지 저장")
                                    
                                    Image(systemName: "paperplane")
                                }
                            }
                        }
                    } label: {
                        ZStack {
                            Circle()
                                .foregroundStyle(Color.postieOrange)
                                .frame(width:70,height:70)
                            
                            Image(systemName: "envelope.open")
                                .foregroundStyle(Color.postieLightGray)
                                .font(.title2)
                                .offset(y: -3)
                        }
                    }
                    .foregroundStyle(Color.postieLightGray)
                    .shadow(color: Color.postieBlack.opacity(0.1), radius: 3, x: 3, y: 3)
                    .imageScale(.large)
                    .padding()
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("\(recipient)")
                            .bold()
                            .foregroundStyle(Color.postieOrange)
                    }
                }
            }
            .foregroundStyle(Color.postieBlack)
            .tint(Color.postieBlack)
        }
    }
}

//#Preview {
//    GroupedListLetterView()
//}
