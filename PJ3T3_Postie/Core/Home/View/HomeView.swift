//
//  HomeView.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 1/17/24.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var firestoreManager = FirestoreManager.shared
    @ObservedObject var storageManager = StorageManager.shared
    @State private var isSideMenuOpen = false
    @State private var isTabGroupButton = true
    @State private var currentGroupPage: Int = 0
    @State private var isThemeGroupButton: Int = 0
    @State private var currentColorPage: Int = 0
    
    var body: some View {
        let postieColors = ThemeManager.themeColors[isThemeGroupButton]
        
        NavigationStack {
            ZStack {
                postieColors.backGroundColor
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    HStack {
                        Text("Postie")
                            .font(.custom("SourceSerifPro-Black", size: 40))
                            .foregroundStyle(postieColors.tintColor)
                        
                        Spacer()
                        
                        Button(action: {
                        }) {
                            Image(systemName: "magnifyingglass")
                                .imageScale(.large)
                                .foregroundStyle(postieColors.tabBarTintColor)
                                .padding(.horizontal, 5)
                        }
                        
                        Button(action: {
                            withAnimation {
                                self.isSideMenuOpen.toggle()
                            }
                        }) {
                            Image(systemName: "line.horizontal.3")
                                .imageScale(.large)
                                .foregroundStyle(postieColors.tabBarTintColor)
                        }
                    }
                    .background(postieColors.backGroundColor)
                    .padding(.horizontal)
                    
                    ZStack(alignment: .bottomTrailing) {
                        ScrollView {
                            if isTabGroupButton {
                                VStack {
                                    GroupedLetterView(isThemeGroupButton: $isThemeGroupButton)
                                }
                            } else {
                                VStack {
                                    ListLetterView(isThemeGroupButton: $isThemeGroupButton)
                                }
                            }
                            
                            // ScrollView margin 임시
                            Rectangle()
                                .frame(height: 80)
                                .foregroundStyle(postieColors.tabBarTintColor.opacity(0))
                        }
                        .background(postieColors.backGroundColor)
                        
                        AddLetterButton(isThemeGroupButton: $isThemeGroupButton)
                    }
                    .preferredColorScheme(isThemeGroupButton == 4 ? .dark : .light)
                }
                
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
                SideMenuView(isSideMenuOpen: $isSideMenuOpen, currentGroupPage: $currentGroupPage, isTabGroupButton: $isTabGroupButton, isThemeGroupButton: $isThemeGroupButton, currentColorPage: $currentColorPage)
                    .offset(x: isSideMenuOpen ? 0 : UIScreen.main.bounds.width)
                    .animation(.easeInOut, value: 1)
            }
        }
    }
}

// 임시 세팅뷰
struct SideMenuView: View {
    @ObservedObject var authManager = AuthManager.shared
    @Binding var isSideMenuOpen: Bool
    @Binding var currentGroupPage: Int
    @Binding var isTabGroupButton: Bool
    @Binding var isThemeGroupButton: Int
    @Binding var currentColorPage: Int
    @State private var isToggleOn = false
    
    var body: some View {
        let user = authManager.currentUser
        let postieColors = ThemeManager.themeColors[isThemeGroupButton]
        
        HStack {
            Spacer()
            
            VStack(alignment: .leading) {
                HStack {
                    Text("Setting")
                        .font(.custom("SourceSerifPro-Black", size: 32))
                        .foregroundStyle(postieColors.tintColor)
                    
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
                    .foregroundStyle(postieColors.dividerColor)
                
                DividerView(isThemeGroupButton: $isThemeGroupButton)
                
                NavigationLink(destination: ProfileView(isThemeGroupButton: $isThemeGroupButton)) {
                    HStack {
                        ZStack {
                            Circle()
                                .frame(width: 80,height: 80)
                                .foregroundStyle(postieColors.profileColor)
                            
                            Image("postyReceiving")
                                .resizable()
                                .frame(width: 80,height: 80)
                        }
                        
                        VStack(alignment: .leading) {
                            Text(String(user?.fullName ?? ""))
                            
                            Text(user?.email ?? "")
                        }
                        .foregroundStyle(postieColors.tabBarTintColor)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundStyle(postieColors.dividerColor)
                    }
                    .padding(.bottom)
                }
                
                Text("테마 설정")
                    .foregroundStyle(postieColors.dividerColor)
                
                DividerView(isThemeGroupButton: $isThemeGroupButton)
                
                NavigationLink(destination: ThemeView(isThemeGroupButton: $isThemeGroupButton, currentColorPage: $currentColorPage, isTabGroupButton: $isTabGroupButton, currentGroupPage: $currentGroupPage)) {
                    HStack {
                        Text("테마 설정 하기")
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundStyle(postieColors.dividerColor)
                    }
                    .padding(.bottom)
                }
                
                Text("앱 설정")
                    .foregroundStyle(postieColors.dividerColor)
                
                DividerView(isThemeGroupButton: $isThemeGroupButton)
                
                HStack {
                    Text("공지사항")
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundStyle(postieColors.dividerColor)
                }
                .padding(.bottom)
                
                HStack {
                    Text("문의하기")
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundStyle(postieColors.dividerColor)
                }
                .padding(.bottom)
                
                HStack {
                    Text("이용약관 및 개인정보 방침")
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundStyle(postieColors.dividerColor)
                }
                .padding(.bottom)
                
                HStack {
                    Text("앱 정보")
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundStyle(postieColors.dividerColor)
                }
                .padding(.bottom)
                
                Spacer()
                
                Text("COPYRIGHT 2024 ComeOn12 RIGHTS RESERVED")
                    .font(.caption2)
                    .foregroundStyle(postieColors.dividerColor)
            }
            .padding()
            .frame(width: UIScreen.main.bounds.width - 100 , alignment: .leading)
            .foregroundStyle(postieColors.tabBarTintColor)
            .background(postieColors.backGroundColor)
        }
        .tint(postieColors.tabBarTintColor)
    }
}

struct AddLetterButton: View {
    @Binding var isThemeGroupButton: Int
    
    var body: some View {
        let postieColors = ThemeManager.themeColors[isThemeGroupButton]
        
        Menu {
            NavigationLink(destination: AddLetterView(isReceived: false)) {
                Label("나의 느린 우체통", systemImage: "envelope.open.badge.clock")
            }
            
            NavigationLink(destination: AddLetterView(isReceived: true)) {
                Label("받은 편지 저장", systemImage: "envelope.open")
            }
            
            NavigationLink(destination: AddLetterView(isReceived: false)) {
                Label("보낸 편지 저장", systemImage: "paperplane")
            }
        } label: {
            ZStack {
                Circle()
                    .foregroundStyle(postieColors.tintColor)
                    .frame(width: 70, height: 70)
                
                Image(systemName: "envelope.open")
                    .foregroundStyle(isThemeGroupButton == 4 ? Color.postieBlack : Color.postieWhite)
                    .font(.title2)
                    .offset(y: -3)
            }
        }
        .foregroundStyle(Color.postieLightGray)
        .shadow(color: Color.postieBlack.opacity(0.1), radius: 3, x: 3, y: 3)
        .imageScale(.large)
        .padding()
    }
}

struct DividerView: View {
    @Binding var isThemeGroupButton: Int
    
    var body: some View {
        let postieColors = ThemeManager.themeColors[isThemeGroupButton]
        
        Rectangle()
            .fill(postieColors.dividerColor)
            .frame(height: 1)
            .padding(.bottom)
    }
}

#Preview {
    HomeView()
}
