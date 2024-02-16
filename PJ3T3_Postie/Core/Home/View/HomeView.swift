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
    @AppStorage("profileImage") private var profileImage: String = "postyReceivingLineColor"
    @AppStorage("profileImageTemp") private var profileImageTemp: String = ""
    @AppStorage("isThemeGroupButton") private var isThemeGroupButton: Int = 0
    
    @State private var isMenuActive = false
    @State private var isSideMenuOpen = false
    @State private var currentGroupPage: Int = 0
    @State private var currentColorPage: Int = 0
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    postieColors.backGroundColor
                        .ignoresSafeArea()
                    
                    if firestoreManager.letters.isEmpty {
                        VStack {
                            Image(isThemeGroupButton == 4 ? "postySendingSketchWhite" : "postySendingSketch")
                                .resizable()
                                .scaledToFit()
                                .frame(width: geometry.size.width * 0.7)
                                .opacity(0.5)
                            
                            Text("저장된 편지가 없어요...")
                                .font(.headline)
                                .foregroundStyle(postieColors.tintColor)
                            
                            Text("우측 하단 편지봉투 버튼을 이용해 주고받은 편지를 저장해주세요!")
                                .foregroundStyle(postieColors.dividerColor)
                        }
                        .padding()
                    }
                    
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
                            .disabled(isMenuActive)
                            
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
                        .disabled(isMenuActive)
                        .padding(.horizontal)
                        
                        ZStack(alignment: .bottomTrailing) {
                            ScrollView {
                                if isTabGroupButton {
                                    VStack {
                                        GroupedLetterView(isMenuActive: $isMenuActive, homeWidth: geometry.size.width)
                                    }
                                } else {
                                    VStack {
                                        ListLetterView(isMenuActive: $isMenuActive)
                                    }
                                }
                                
                                // ScrollView margin
                                Rectangle()
                                    .frame(height: 80)
                                    .foregroundStyle(postieColors.tabBarTintColor.opacity(0))
                            }
                            
                            AddLetterButton(isMenuActive: $isMenuActive)
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
                    
                    SideMenuView(isSideMenuOpen: $isSideMenuOpen, currentGroupPage: $currentGroupPage, isTabGroupButton: $isTabGroupButton, currentColorPage: $currentColorPage, profileImage: $profileImage, profileImageTemp: $profileImageTemp)
                        .offset(x: isSideMenuOpen ? 0 : UIScreen.main.bounds.width)
                        .animation(.easeInOut, value: 1)
                }
                .onTapGesture {
                    if self.isMenuActive {
                        self.isMenuActive = false
                    }
                }
            }
        }
    }
}

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
                    SettingItemsView(imageName: "paintpalette", title: "테마 설정")
                }
                
                Text("앱 설정")
                    .font(.subheadline)
                    .foregroundStyle(postieColors.dividerColor)
                
                DividerView()
                    .padding(.bottom)
                
                NavigationLink(destination: AlertView()) {
                    SettingItemsView(imageName: "bell", title: "알림 설정")
                }
                
                NavigationLink(destination: NoticeView()) {
                    SettingItemsView(imageName: "megaphone", title: "공지사항")
                }
                
                NavigationLink(destination: QuestionView()) {
                    SettingItemsView(imageName: "questionmark.circle", title: "문의하기")
                }
                
                NavigationLink(destination: InformationView()) {
                    SettingItemsView(imageName: "info.circle", title: "앱 정보")
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

struct SettingItemsView: View {
    var imageName: String
    var title: String
    
    var body: some View {
        HStack {
            Image(systemName: imageName)
                .font(imageName == "megaphone" ? .callout : .body)
            
            Text(title)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundStyle(postieColors.dividerColor)
        }
        .padding(.bottom)
    }
}

struct AddLetterButton: View {
    @AppStorage("isThemeGroupButton") private var isThemeGroupButton: Int = 0
    @Binding var isMenuActive: Bool
    
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
        .onTapGesture {
            self.isMenuActive.toggle()
        }
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
