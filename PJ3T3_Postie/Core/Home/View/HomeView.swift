//
//  HomeView.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 1/17/24.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var firestoreManager = FirestoreManager.shared
    @AppStorage("isTabGroupButton") private var isTabGroupButton: Bool = true
    @AppStorage("profileImage") private var profileImage: String = "postyReceivingBeige"
    @AppStorage("profileImageTemp") private var profileImageTemp: String = ""
    @AppStorage("isThemeGroupButton") private var isThemeGroupButton: Int = 0
    
    @State private var isSideMenuOpen = false
    @State private var currentGroupPage: Int = 0
    @State private var currentColorPage: Int = 0
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    postieColors.backGroundColor
                        .ignoresSafeArea()
                    
                    VStack(spacing: 0) {
                        HStack {
                            Text("Postie")
                                .font(.custom("SourceSerifPro-Black", size: 40))
                                .foregroundStyle(postieColors.tintColor)
                            
                            Spacer()
                            
                            NavigationLink {
                                SearchView()
                            } label: {
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
                                        GroupedLetterView(homeWidth: geometry.size.width)
                                    }
                                } else {
                                    VStack {
                                        ListLetterView()
                                    }
                                }
                                
                                // ScrollView margin 임시
                                Rectangle()
                                    .frame(height: 80)
                                    .foregroundStyle(postieColors.tabBarTintColor.opacity(0))
                            }
                            .background(postieColors.backGroundColor)
                            
                            AddLetterButton()
                        }
                        .preferredColorScheme(isThemeGroupButton == 4 ? .dark : .light)
                    }
                    
                    if firestoreManager.letters.isEmpty {
                        VStack {
                            Image("postySmileSketch")
                                .resizable()
                                .scaledToFit()
                                .frame(width: geometry.size.width * 0.7)
                                .opacity(0.5)
                            
                            Text("\n저장된 편지가 없어요! 플로팅 버튼을 이용해 주고받은 편지를 저장해주세요!")
                                .font(.callout)
                                .foregroundStyle(postieColors.dividerColor)
                        }
                        .padding()
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
                    
                    SideMenuView(isSideMenuOpen: $isSideMenuOpen, currentGroupPage: $currentGroupPage, isTabGroupButton: $isTabGroupButton, currentColorPage: $currentColorPage, profileImage: $profileImage, profileImageTemp: $profileImageTemp)
                        .offset(x: isSideMenuOpen ? 0 : UIScreen.main.bounds.width)
                        .animation(.easeInOut, value: 1)
                }
            }
        }
    }
}

// 임시 세팅뷰
struct SideMenuView: View {
    @ObservedObject var authManager = AuthManager.shared
    
    @AppStorage("isThemeGroupButton") private var isThemeGroupButton: Int = 0
    @Binding var isSideMenuOpen: Bool
    @Binding var currentGroupPage: Int
    @Binding var isTabGroupButton: Bool
    @Binding var currentColorPage: Int
    @Binding var profileImage: String
    @Binding var profileImageTemp: String
    @State private var isToggleOn = false
    
    var body: some View {
        let user = authManager.currentUser
        
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
                    .font(.subheadline)
                    .foregroundStyle(postieColors.dividerColor)
                
                DividerView()
                    .padding(.bottom)
                
                NavigationLink(destination: ProfileView(profileImage: $profileImage, profileImageTemp: $profileImageTemp)) {
                    HStack {
                        ZStack {
                            Circle()
                                .frame(width: 80,height: 80)
                                .foregroundStyle(postieColors.profileColor)
                            
                            Image(profileImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .offset(y: -4)
                        }
                        
                        VStack(alignment: .leading) {
                            Text(String(user?.nickname ?? ""))
                            
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
                    .font(.subheadline)
                    .foregroundStyle(postieColors.dividerColor)
                
                DividerView()
                    .padding(.bottom)
                
                NavigationLink(destination: ThemeView(currentColorPage: $currentColorPage, isTabGroupButton: $isTabGroupButton, currentGroupPage: $currentGroupPage)) {
                    HStack {
                        Image(systemName: "paintpalette")
                        
                        Text("테마 설정 하기")
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundStyle(postieColors.dividerColor)
                    }
                    .padding(.bottom)
                }
                
                Text("앱 설정")
                    .font(.subheadline)
                    .foregroundStyle(postieColors.dividerColor)
                
                DividerView()
                    .padding(.bottom)
                
                NavigationLink(destination: AlertView()) {
                    HStack {
                        Image(systemName: "bell")
                        
                        Text("알림설정")
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundStyle(postieColors.dividerColor)
                    }
                    .padding(.bottom)
                }
                
                NavigationLink(destination: NoticeView()) {
                    HStack {
                        Image(systemName: "megaphone")
                            .font(.subheadline)
                        
                        Text("공지사항")
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundStyle(postieColors.dividerColor)
                    }
                    .padding(.bottom)
                }
                
                NavigationLink(destination: QuestionView()) {
                    HStack {
                        Image(systemName: "questionmark.circle")
                        
                        Text("문의하기")
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundStyle(postieColors.dividerColor)
                    }
                    .padding(.bottom)
                }
                
                NavigationLink(destination: InformationView()) {
                    HStack {
                        Image(systemName: "info.circle")
                        
                        Text("앱 정보")
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundStyle(postieColors.dividerColor)
                    }
                    .padding(.bottom)
                }
                
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
        .onAppear {
            currentColorPage = isThemeGroupButton
            currentGroupPage = isTabGroupButton ? 0 : 1
        }
    }
}

struct AddLetterButton: View {
    @AppStorage("isThemeGroupButton") private var isThemeGroupButton: Int = 0
    
    var body: some View {
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
    var body: some View {
        Rectangle()
            .fill(postieColors.dividerColor)
            .frame(height: 1)
    }
}

private func getValueFromUserDefaults<T>(key: String, defaultValue: T) -> T {
    return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
}

//#Preview {
//    HomeView()
//}
