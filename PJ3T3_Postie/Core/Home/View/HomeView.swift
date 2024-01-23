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
    @State private var isSideMenuOpen = false
    
    var body: some View {
        ZStack {
            NavigationStack {
                ZStack(alignment: .bottomTrailing) {
                    ScrollView {
                        VStack {
                            NavigationLink(destination: LetterDetailView(letter: Letter.preview)) {
                                receiveLetterView(sender: "최웅", date: "2024.01.08", summary: "이런 추운 겨울만 되면 항상 너가 생각나")
                            }
                            
                            NavigationLink(destination: LetterDetailView(letter: Letter.preview)) {
                                sendLetterView(sender: "최웅", date: "2024.01.09", summary: "넌 뭔데 그렇게 아무렇지 않게 구는건데?")
                            }
                            
                            NavigationLink(destination: LetterDetailView(letter: Letter.preview)) {
                                receiveLetterView(sender: "할머니", date: "2024.01.09", summary: "나 때문에 살지마, 연수야")
                            }
                            
                            NavigationLink(destination: LetterDetailView(letter: Letter.preview)) {
                                receiveLetterView(sender: "최웅", date: "2024.01.11", summary: "보고 싶었어 항상. 보고... 싶었어")
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
                            
                            ZStack {
                                Image(systemName: "envelope")
                                    .font(.title2)
                                    .offset(y: -5)
                                
                                Image(systemName: "plus.circle")
                                    .font(.footnote)
                                    .offset(x:15, y:9)
                            }
                        }
                    })
                    .foregroundStyle(Color(hex: 0x1E1E1E))
                    .shadow(color: Color.black.opacity(0.1), radius: 3, x: 3, y: 3)
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
                .foregroundStyle(Color(hex: 0x1E1E1E))
                .navigationBarItems(leading: (
                    HStack {
                        Text("Postie")
                            .font(.custom("SourceSerifPro-Black", size: 40))
                            .foregroundStyle(Color.black)
                    }), trailing: (
                        Button(action: {
                            withAnimation {
                                self.isSideMenuOpen.toggle()
                            }
                        }) {
                            Image(systemName: "line.horizontal.3")
                                .imageScale(.large)
                        }
                        
                    ))
            }
            .toolbarBackground(
                Color(hex: 0xF5F1E8),
                for: .tabBar)
            if isSideMenuOpen {
                Color.black.opacity(0.5)
                    .onTapGesture {
                        withAnimation {
                            self.isSideMenuOpen.toggle()
                        }
                    }
                    .edgesIgnoringSafeArea(.all)
            }
            
//            SettingView()
//                .offset(x: isSideMenuOpen ? 0 : UIScreen.main.bounds.width)
//                .animation(.easeInOut)
        }
        .tint(Color.init(hex: 0x979797))
    }
}

func receiveLetterView(sender: String, date: String, summary: String) -> some View {
    HStack {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text("From.")
                        .font(.custom("SourceSerifPro-Black", size: 18))
                        .foregroundColor(.black)
                    
                    Text("\(sender)")
                        .foregroundStyle(Color(hex: 0x1E1E1E))
                    
                    Spacer()
                    
                    Text(date)
                        .font(.custom("SourceSerifPro-Light", size: 18))
                        .foregroundStyle(Color(hex: 0x1E1E1E))
                    
                    ZStack {
                        Image(systemName: "water.waves")
                            .font(.headline)
                            .offset(x:18)
                        Image(systemName: "sleep.circle")
                            .font(.largeTitle)
                    }
                    .foregroundStyle(Color.init(hex: 0x979797))
                }
                
                Spacer()
                
                if summary != "" {
                    Text("\"\(summary)\"")
                }
            }
        }
        .padding()
        .frame(width: 300, height: 130)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(Color(hex: 0xD1CEC7).opacity(0.65))
                .shadow(color: Color.black.opacity(0.1), radius: 3, x: 3, y: 3)
        )
        
        Spacer()
    }
}

func sendLetterView(sender: String, date: String, summary: String) -> some View {
    HStack {
        Spacer()
        
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text("To.")
                        .font(.custom("SourceSerifPro-Black", size: 18))
                        .foregroundColor(.black)
                    
                    Text("\(sender)")
                        .foregroundStyle(Color(hex: 0x1E1E1E))
                    
                    Spacer()
                    
                    Text(date)
                        .font(.custom("SourceSerifPro-Light", size: 18))
                        .foregroundStyle(Color(hex: 0x1E1E1E))
                    
                    ZStack {
                        Image(systemName: "water.waves")
                            .font(.headline)
                            .offset(x:18)
                        Image(systemName: "sleep.circle")
                            .font(.largeTitle)
                    }
                    .foregroundStyle(Color.init(hex: 0x979797))
                }
                
                Spacer()
                
                if summary != "" {
                    Text("\"\(summary)\"")
                }
            }
        }
        .padding()
        .frame(width: 300, height: 130)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(Color(hex: 0xF7F7F7).opacity(0.65))
                .shadow(color: Color.black.opacity(0.1), radius: 3, x: 3, y: 3)
        )
    }
}

#Preview {
    HomeView()
}
