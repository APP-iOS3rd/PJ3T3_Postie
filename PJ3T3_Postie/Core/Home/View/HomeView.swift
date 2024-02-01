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
    @State private var currentGroupPage: Int = 0
    
    var body: some View {
        ZStack {
            NavigationStack {
                ZStack(alignment: .bottomTrailing) {
                    ScrollView {
                        if currentGroupPage == 0 {
                            VStack {
                                GroupLetterView(letterCount: 3, title: "Favorite", content: "즐겨찾기 한 편지 꾸러미들")
                                    .padding(.bottom, 10)
                            }
                            .padding()
                        } else {
                            VStack {
                                LetterDataListViewFB()
                            }
                            .padding()
                        }
                        // ScrollView margin 임시
                        Rectangle()
                            .frame(height: 70)
                            .foregroundStyle(Color.black.opacity(0))
                    }
                    .searchable(text: $search)
                    .background(Color(hex: 0xF5F1E8))
                    
                    Menu {
                        NavigationLink(destination: AddLetterView(isReceived: false)) {
                            Button (action: {
                            }) {
                                HStack {
                                    Text("나의 느린 우체통")
                                    
                                    Image(systemName: "envelope.open.badge.clock")
                                }
                            }
                        }
                        
                        NavigationLink(destination: AddLetterView(isReceived: true)) {
                            Button (action: {
                            }) {
                                HStack {
                                    Text("받은 편지 저장")
                                    
                                    Image(systemName: "envelope.open")
                                }
                            }
                        }
                        
                        NavigationLink(destination: AddLetterView(isReceived: false)) {
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
            SideMenuView(isSideMenuOpen: $isSideMenuOpen, currentGroupPage: $currentGroupPage)
                .offset(x: isSideMenuOpen ? 0 : UIScreen.main.bounds.width)
                .animation(.easeInOut)
        }
        .tint(Color.init(hex: 0x1E1E1E))
    }
}

// 임시 세팅뷰
struct SideMenuView: View {
    @Binding var isSideMenuOpen: Bool
    @Binding var currentGroupPage: Int
    @State private var isToggleOn = false
    
    var body: some View {
        HStack {
            Spacer()
            
            VStack(alignment: .leading) {
                HStack {
                    Text("Setting")
                        .font(.custom("SourceSerifPro-Black", size: 32))
                        .foregroundStyle(Color(hex: 0xFF5733))
                    
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
                                .foregroundStyle(Color(hex: 0xE6E2DC))
                            
                            Image("Posty_Receiving")
                                .resizable()
                                .frame(width: 80,height: 80)
                                .offset(x: -4, y: 5)
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
                    .padding(.bottom)
                
                NavigationLink(destination: ThemeView(currentGroupPage: $currentGroupPage)) {
                    HStack {
                        Text("테마 설정 하기")
                        
                        Spacer()
                        
                        Image(systemName: "greaterthan")
                            .foregroundStyle(Color.gray)
                    }
                    .padding(.bottom)
                }
                
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

struct LetterDataListViewFB: View {
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
                            .foregroundStyle(Color(hex: 0xFFFFFF))
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

struct GroupLetterView: View { // 그룹 뷰 용도. 임시
    var letterReceivedGrouped: [String] = []
    var letterWritedGrouped: [String] = []
    var letterGrouped: [String] = []
    let letterCount: Int
    let title: String
    let content: String
    @ObservedObject var firestoreManager = FirestoreManager.shared
    @ObservedObject var authManager = AuthManager.shared
    
    var body: some View {
        // recipient 에서 중복 된것을 제외 후 letterReceivedGrouped 에 삽입
        let letterReceivedGrouped: [String] = Array(Set(firestoreManager.letters.map { $0.recipient }.filter { !$0.isEmpty }))
        // writer 에서 중복 된것을 제외 후 letterWritedGrouped 에 삽입
        let letterWritedGrouped: [String] = Array(Set(firestoreManager.letters.map { $0.writer }.filter { !$0.isEmpty }))
        // letterReceivedGrouped와 letterWritedGrouped를 합친 후 중복 제거
        let letterGrouped: [String] = Array(Set(letterReceivedGrouped + letterWritedGrouped))
        // 본인 이름 항목 제거
        // "me" << 추후에는 authManager.currentUser?.fullName 로 해야함
        let filteredLetterGrouped: [String] = letterGrouped.filter { $0 != "me" }
        
        ForEach(filteredLetterGrouped, id: \.self) { recipient in
            HStack {
                ZStack {
                    if letterCount > 2 {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(Color(hex: 0xFCFBF7))
                            .frame(width: 350, height: 130)
                            .offset(x: 10, y: 10)
                            .shadow(color: Color.black.opacity(0.1), radius: 3, x: 3, y: 3)
                    }
                    
                    if letterCount > 1 {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(Color(hex: 0xFCFBF7))
                            .frame(width: 350, height: 130)
                            .offset(x: 5, y: 5)
                            .shadow(color: Color.black.opacity(0.1), radius: 3, x: 3, y: 3)
                    }
                    
                    HStack {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("From.")
                                    .font(.custom("SourceSerifPro-Black", size: 18))
                                    .foregroundColor(.black)
                                
                                Text("\(recipient)")
                                    .foregroundStyle(Color(hex: 0x1E1E1E))
                                
                                Spacer()
                                
                                Text(" ") // date
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
                            
                            Text("\"\"")
                        }
                    }
                    .padding()
                    .frame(width: 350, height: 130)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(Color(hex: 0xFCFBF7))
                            .shadow(color: Color.black.opacity(0.1), radius: 3, x: 3, y: 3)
                    )
                }
                
                Spacer()
            }
        }
    }
}

#Preview {
    HomeView()
}
