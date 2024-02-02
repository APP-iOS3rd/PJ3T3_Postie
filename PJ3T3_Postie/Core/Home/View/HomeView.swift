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
    @State private var isTabGroupButton = true
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.postieBeige
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    HStack {
                        Text("Postie")
                            .font(.custom("SourceSerifPro-Black", size: 40))
                            .foregroundStyle(Color.postieOrange)
                        
                        Spacer()
                        
                        Button(action: {
                        }) {
                            Image(systemName: "magnifyingglass")
                                .imageScale(.large)
                                .padding(.horizontal, 5)
                        }
                        
                        Button(action: {
                            withAnimation {
                                self.isSideMenuOpen.toggle()
                            }
                        }) {
                            Image(systemName: "line.horizontal.3")
                                .imageScale(.large)
                        }
                    }
                    .background(Color.postieBeige)
                    .padding(.horizontal)
                    
                    ZStack(alignment: .bottomTrailing) {
                        ScrollView {
                            if currentGroupPage == 0 {
                                VStack {
                                    GroupedLetterView()
                                }
                            } else {
                                VStack {
                                    ListLetterView()
                                }
                                .padding()
                            }
                            // ScrollView margin 임시
                            Rectangle()
                                .frame(height: 80)
                                .foregroundStyle(Color.postieBlack.opacity(0))
                        }
                        .background(Color.postieBeige)
                        
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
                                    .foregroundStyle(Color.postieOrange)
                                    .frame(width:70,height:70)
                                
                                Image(systemName: "envelope.open")
                                    .foregroundStyle(Color.postieWhite)
                                    .font(.title2)
                                    .offset(y: -3)
                            }
                        }
                        .foregroundStyle(Color.postieLightGray)
                        .shadow(color: Color.postieBlack.opacity(0.1), radius: 3, x: 3, y: 3)
                        .imageScale(.large)
                        .padding()
                    }
                    .preferredColorScheme(.light)
                }
                .background(Color.postieBeige)
                
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
                SideMenuView(isSideMenuOpen: $isSideMenuOpen, currentGroupPage: $currentGroupPage, isTabGroupButton: $isTabGroupButton)
                    .offset(x: isSideMenuOpen ? 0 : UIScreen.main.bounds.width)
                    .animation(.easeInOut, value: 1)
            }
            .tint(Color.postieBlack)
        }
    }
}

// 임시 세팅뷰
struct SideMenuView: View {
    @Binding var isSideMenuOpen: Bool
    @Binding var currentGroupPage: Int
    @Binding var isTabGroupButton: Bool
    @State private var isToggleOn = false
    
    var body: some View {
        HStack {
            Spacer()
            
            VStack(alignment: .leading) {
                HStack {
                    Text("Setting")
                        .font(.custom("SourceSerifPro-Black", size: 32))
                        .foregroundStyle(Color.postieOrange)
                    
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
                    .foregroundStyle(Color.postieDarkGray)
                
                Rectangle()
                    .foregroundStyle(Color.postieDarkGray)
                    .frame(height: 1)
                    .padding(.bottom)
                
                NavigationLink(destination: ProfileView()) {
                    HStack {
                        ZStack {
                            Circle()
                                .frame(width: 80,height: 80)
                                .foregroundStyle(Color.postieGray)
                            
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
                        
                        Image(systemName: "chevron.right")
                            .foregroundStyle(Color.postieDarkGray)
                    }
                    .padding(.bottom)
                }
                
                Text("테마 설정")
                    .foregroundStyle(Color.postieDarkGray)
                
                Rectangle()
                    .foregroundStyle(Color.postieDarkGray)
                    .frame(height: 1)
                    .padding(.bottom)
                
                NavigationLink(destination: ThemeView(isTabGroupButton: $isTabGroupButton, currentGroupPage: $currentGroupPage)) {
                    HStack {
                        Text("테마 설정 하기")
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundStyle(Color.postieDarkGray)
                    }
                    .padding(.bottom)
                }
                
                Text("앱 설정")
                    .foregroundStyle(Color.postieDarkGray)
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(Color.postieDarkGray)
                    .padding(.bottom)
                
                HStack {
                    Text("공지사항")
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundStyle(Color.postieDarkGray)
                }
                .padding(.bottom)
                
                HStack {
                    Text("문의하기")
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundStyle(Color.postieDarkGray)
                }
                .padding(.bottom)
                
                HStack {
                    Text("이용약관 및 개인정보 방침")
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundStyle(Color.postieDarkGray)
                }
                .padding(.bottom)
                
                HStack {
                    Text("앱 정보")
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundStyle(Color.postieDarkGray)
                }
                .padding(.bottom)
                
                Spacer()
                
                Text("COPYRIGHT 2024 ComeOn12 RIGHTS RESERVED")
                    .font(.caption2)
                    .foregroundStyle(Color.postieDarkGray)
            }
            .padding()
            .frame(width: UIScreen.main.bounds.width - 100 , alignment: .leading)
            .foregroundStyle(Color.postieBlack)
            .background(Color.postieBeige)
        }
        .tint(Color.postieBlack)
    }
}

#Preview {
    HomeView()
}
