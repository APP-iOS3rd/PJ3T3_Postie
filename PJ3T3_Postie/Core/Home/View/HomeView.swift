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
    @ObservedObject var firestoreManager = FirestoreManager.shared
    @ObservedObject var storageManager = StorageManager.shared
    
    var body: some View {
        ZStack {
            NavigationStack {
                ZStack(alignment: .bottomTrailing) {
                    ScrollView {
                        VStack {
                            NavigationLink(destination: LetterDetailView(letter: Letter.preview)) {
                                ReceiveLetterView(letter: Letter.preview)
                            }
                            
                            NavigationLink(destination: LetterDetailView(letter: Letter.preview)) {
                                SendLetterView(letter: Letter.preview)
                            }
                            
                            NavigationLink(destination: LetterDetailView(letter: Letter.preview)) {
                                ReceiveLetterView(letter: Letter.preview)
                            }
                            
                            NavigationLink(destination: LetterDetailView(letter: Letter.preview)) {
                                ReceiveLetterView(letter: Letter.preview)
                            }
                            NavigationLink(destination: LetterDetailView(letter: Letter.preview)) {
                                SendLetterView(letter: Letter.preview)
                            }
                            
                            LetterDataListViewFB()
                            
                            // ScrollView margin 임시
                            Rectangle()
                                .frame(height: 70)
                                .foregroundStyle(Color.black.opacity(0))
                        }
                        .padding()
                    }
                    .searchable(text: $search)
                    .background(Color(hex: 0xF5F1E8))
                    
                    Menu {
                        NavigationLink(destination: AddLetterView(isSendingLetter: true)) {
                            Button (action: {
                            }) {
                                HStack {
                                    Text("나의 느린 우체통")
                                    
                                    Image(systemName: "envelope.open.badge.clock")
                                }
                            }
                        }
                        
                        NavigationLink(destination: AddLetterView(isSendingLetter: false)) {
                            Button (action: {
                            }) {
                                HStack {
                                    Text("받은 편지 저장")
                                    
                                    Image(systemName: "envelope.open")
                                }
                            }
                        }
                        
                        NavigationLink(destination: AddLetterView(isSendingLetter: false)) {
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
                                .foregroundStyle(Color(hex: 0xFF5733))
                                .frame(width:70,height:70)
                            
                            Image(systemName: "envelope.open")
                                .foregroundStyle(Color(hex: 0xF7F7F7))
                                .font(.title2)
                                .offset(y: -3)
                        }
                    }
                    .foregroundStyle(Color(hex: 0xF7F7F7))
                    .shadow(color: Color.black.opacity(0.1), radius: 3, x: 3, y: 3)
                    .imageScale(.large)
                    .padding()
                }
                .foregroundStyle(Color(hex: 0x1E1E1E))
                .navigationBarItems(leading: (
                    HStack {
                        Text("Postie")
                            .font(.custom("SourceSerifPro-Black", size: 40))
                            .foregroundStyle(Color(hex: 0xFF5733))
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
            
            // 세팅 뷰
            //            SettingView()
            //                .offset(x: isSideMenuOpen ? 0 : UIScreen.main.bounds.width)
            //                .animation(.easeInOut)
            // 임시 세팅뷰
            SideMenuView(isSideMenuOpen: $isSideMenuOpen)
                .offset(x: isSideMenuOpen ? 0 : UIScreen.main.bounds.width)
                .animation(.easeInOut)
        }
        .tint(Color.init(hex: 0x1E1E1E))
    }
}

// 임시 세팅뷰
struct SideMenuView: View {
    @Binding var isSideMenuOpen: Bool
    @State private var isToggleOn = false
    
    var body: some View {
        HStack {
            Spacer()
            
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation {
                            self.isSideMenuOpen.toggle()
                        }
                    }) {
                        Image(systemName: "xmark")
                            .imageScale(.large)
                    }
                }
                
                Text("Setting")
                    .font(.custom("SourceSerifPro-Black", size: 32))
                    .foregroundStyle(Color(hex: 0xFF5733))
                
                Text("프로필 설정")
                    .foregroundStyle(Color.gray)
                
                Rectangle()
                    .foregroundStyle(Color.gray)
                    .frame(height: 1)
                    .padding(.bottom)
                
                NavigationLink(destination: ProfileView()) {
                    HStack {
                        ZStack {
                            Circle()
                                .frame(width: 80,height: 80)
                                .foregroundStyle(Color(hex: 0xD1CEC7))
                            
                            Text("Postie")
                                .foregroundStyle(Color.black)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Postie_test")
                            Text("postie@test.com")
                        }
                        
                        Spacer()
                        
                        Image(systemName: "greaterthan")
                            .foregroundStyle(Color.gray)
                    }
                    .padding(.bottom)
                }
                
                Text("테마 설정")
                    .foregroundStyle(Color.gray)
                
                Rectangle()
                    .foregroundStyle(Color.gray)
                    .frame(height: 1)
                
                Toggle("다크모드", isOn: $isToggleOn)
                    .onChange(of: isToggleOn) { _ in
                    }
                    .padding(.bottom)
                
                Text("앱 설정")
                    .foregroundStyle(Color.gray)
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(Color.gray)
                    .padding(.bottom)
                
                HStack {
                    Text("공지사항")
                    
                    Spacer()
                    
                    Image(systemName: "greaterthan")
                        .foregroundStyle(Color.gray)
                }
                .padding(.bottom)
                
                HStack {
                    Text("문의하기")
                    
                    Spacer()
                    
                    Image(systemName: "greaterthan")
                        .foregroundStyle(Color.gray)
                }
                .padding(.bottom)
                
                HStack {
                    Text("이용약관 및 개인정보 방침")
                    
                    Spacer()
                    
                    Image(systemName: "greaterthan")
                        .foregroundStyle(Color.gray)
                }
                .padding(.bottom)
                
                HStack {
                    Text("앱 정보")
                    
                    Spacer()
                    
                    Image(systemName: "greaterthan")
                        .foregroundStyle(Color.gray)
                }
                .padding(.bottom)
                
                Spacer()
                
                Text("COPYRIGHT 2024 ComeOn12 RIGHTS RESERVED")
                    .font(.caption2)
                    .foregroundStyle(Color.gray)
            }
            .padding()
            .frame(width: UIScreen.main.bounds.width - 100 , alignment: .leading)
            .foregroundStyle(Color(hex: 0x1e1e1e))
            .background(Color(hex: 0xF5F1E8))
        }
        .tint(Color(hex: 0x1E1E1E))
    }
}

struct ReceiveLetterView: View {
    let letter: Letter
    
    var body: some View {
        HStack {
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text("From.")
                            .font(.custom("SourceSerifPro-Black", size: 18))
                            .foregroundColor(.black)
                        
                        Text("\(letter.writer)")
                            .foregroundStyle(Color(hex: 0x1E1E1E))
                        
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
                    
                    if letter.summary != "" {
                        Text("\"\(letter.summary)\"")
                    }
                }
            }
            .padding()
            .frame(width: 300, height: 130)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(Color(hex: 0xFCFBF7))
                    .shadow(color: Color.black.opacity(0.1), radius: 3, x: 3, y: 3)
            )
            
            Spacer()
        }
    }
}

struct LetterDataListViewFB: View { // 파베 데이터 불러오기 용도, 임시 뷰, 에러나면 일단 전부 주석처리 해주세요
    @ObservedObject var firestoreManager = FirestoreManager.shared
    
    var body: some View {
        ForEach(firestoreManager.letters, id: \.self) { letter in
            if let imageUrlStrings = letter.imageUrlStrings {
                if !imageUrlStrings.isEmpty {
                    NavigationLink {
                        //ImageAsyncView(imageUrlString: imageUrlStrings)
                    } label: {
                        HStack {
                            Spacer()
                            
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
                                    .foregroundStyle(Color(hex: 0xFFFFFF))
                                    .shadow(color: Color.black.opacity(0.1), radius: 3, x: 3, y: 3)
                            )
                        }
                    }
                }
            } else {
                HStack {
                    Spacer()
                    
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
                            .foregroundStyle(Color(hex: 0xFFFFFF))
                            .shadow(color: Color.black.opacity(0.1), radius: 3, x: 3, y: 3)
                    )
                }
            }
        }
    }
}

struct SendLetterView: View {
    let letter: Letter
    
    var body: some View {
        HStack {
            Spacer()
            
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text("To.")
                            .font(.custom("SourceSerifPro-Black", size: 18))
                            .foregroundColor(.black)
                        
                        Text("\(letter.writer)")
                            .foregroundStyle(Color(hex: 0x1E1E1E))
                        
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
                    
                    if letter.summary != "" {
                        Text("\"\(letter.summary)\"")
                    }
                }
            }
            .padding()
            .frame(width: 300, height: 130)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(Color(hex: 0xFFFFFF))
                    .shadow(color: Color.black.opacity(0.1), radius: 3, x: 3, y: 3)
            )
        }
    }
}

#Preview {
    HomeView()
}
