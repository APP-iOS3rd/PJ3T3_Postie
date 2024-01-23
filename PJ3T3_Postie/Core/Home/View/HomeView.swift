//
//  HomeView.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 1/17/24.
//

import SwiftUI

struct HomeView: View {
    @State private var search: String = ""
    @State private var showAlert = false
    
    var body: some View {
        ZStack {
            NavigationStack {
                ZStack(alignment: .bottomTrailing) {
                    ScrollView {
                        VStack {
                            NavigationLink(destination: LetterDetailView(letter: Letter.preview)) {
                                sendLetterView(sender: "김OO", date: "2024.01.04", receiver: "어피치")
                            }
                            
                            NavigationLink(destination: LetterDetailView(letter: Letter.preview)) {
                                receiveLetterView(sender: "라이언", date: "2024.01.04", receiver: "김OO")
                            }
                        }
                        .padding()
                    }
                    .searchable(text: $search)
                    .background(Color(hex: 0xF5F1E8))
                    
                    Button(action: {
                        showAlert.toggle()
                    }, label: {
                        ZStack {
                            Circle()
                                .foregroundStyle(Color(hex: 0x979797))
                                .frame(width:70,height:70)
                            
                            Image(systemName: "envelope")
                        }
                    })
                    .foregroundStyle(Color(hex: 0x1E1E1E))
                    .imageScale(.large)
                    .padding()
                    .alert("편지 저장 하기", isPresented: $showAlert) {
                        NavigationLink(destination: AddLetterView()) {
                            Button("편지 저장") {
                            }
                        }
                        
                        Button("취소", role: .cancel) {
                        }
                    }
                }
                .navigationBarTitle("Postie")
                .foregroundStyle(Color(hex: 0x1E1E1E))
            }
        }
    }
}

func receiveLetterView(sender: String, date: String, receiver: String) -> some View {
    HStack {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 100, height: 35)
                        .overlay(
                            Text("보내는 사람")
                                .foregroundStyle(Color(hex: 0x1E1E1E))
                        )
                        .foregroundStyle(Color(hex: 0x979797))
                    
                    Text("\(sender)")
                        .foregroundStyle(Color(hex: 0x1E1E1E))
                    
                    Spacer()
                    
                    Image(systemName: "swift")
                        .font(.title)
                        .foregroundStyle(Color(hex: 0x1E1E1E))
                }
                
                Text(" ")
                
                HStack {
                    VStack (alignment: .leading) {
                        Text(date)
                            .foregroundStyle(Color(hex: 0x1E1E1E))
                    }
                    
                    Spacer()
                    
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 90, height: 35)
                        .overlay(
                            Text("받는 사람")
                                .foregroundColor(.black)
                        )
                        .foregroundStyle(Color(hex: 0x979797))
                    
                    Text("\(receiver)")
                        .foregroundStyle(Color(hex: 0x1E1E1E))
                }
            }
        }
        .padding()
        .frame(width: 300)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(Color(hex: 0xD1CEC7))
        )
        
        Spacer()
    }
}

func sendLetterView(sender: String, date: String, receiver: String) -> some View {
    HStack {
        Spacer()
        
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 100, height: 35)
                        .overlay(
                            Text("보내는 사람")
                                .foregroundColor(.black)
                        )
                        .foregroundStyle(Color(hex: 0x979797))
                    
                    Text("\(sender)")
                        .foregroundStyle(Color(hex: 0x1E1E1E))
                    
                    Spacer()
                    
                    Image(systemName: "swift")
                        .foregroundStyle(Color(hex: 0x1E1E1E))
                        .font(.title)
                }
                
                Text(" ")
                
                HStack {
                    VStack (alignment: .leading) {
                        Text(date)
                    }
                    
                    Spacer()
                    
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 90, height: 35)
                        .overlay(
                            Text("받는 사람")
                                .foregroundColor(Color(hex: 0x1E1E1E))
                        )
                        .foregroundStyle(Color(hex: 0x979797))
                    
                    Text("\(receiver)")
                        .foregroundStyle(Color(hex: 0x1E1E1E))
                }
            }
        }
        .padding()
        .frame(width: 300)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(Color(hex: 0xD1CEC7))
        )
    }
}

#Preview {
    HomeView()
}
