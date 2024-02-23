//
//  ContentView.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 1/15/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var authViewModel = AuthManager.shared
    @StateObject private var viewModel = AppViewModel()
    @AppStorage("isThemeGroupButton") private var isThemeGroupButton: Int = 0
    @StateObject private var tabSelection = TabSelection()
    @State var showUpdate: Bool = false
    
    init() {
        let tbAppearance: UITabBarAppearance = UITabBarAppearance()
        tbAppearance.backgroundColor = UIColor.systemBackground
        UITabBar.appearance().scrollEdgeAppearance = tbAppearance
        UITabBar.appearance().standardAppearance = tbAppearance
    }

    var body: some View {
        Group {
            // 로딩 끝나면 화면 재생
            if viewModel.isLoading {
                //ViewModel의 userSession이 Published로 구현되어 있기 때문에 해당 뷰에 업데이트가 발생하면 ContentView에 새로운 userSession값을 가지고 뷰를 재구성하도록 신호를 보낸다.
                // ContentView는 viewModel에 업데이트가 없는지 listen하는 상태
                if authViewModel.userSession != nil { // userSession이 있으면 SettingView를 보여줌
                    if authViewModel.currentUser != nil {
                        TabView(selection: $tabSelection.selectedTab) {
                            HomeView(tabSelection: tabSelection)
                                .tabItem {
                                    Image(systemName: "house")
                                    
                                    Text("홈")
                                }
                                .tag(0)
                            
                            ShopView()
                                .tabItem {
                                    Image(systemName: "cart")
                                    
                                    Text("편지지")
                                }
                                .tag(1)
                            
                            MapView()
                                .tabItem {
                                    Image(systemName: "map")
                                    
                                    Text("지도")
                                }
                                .tag(2)
                            
                            //테스트용 뷰입니다. 배포시 주석처리
//                            FirebaseTestView()
//                                .tabItem {
//                                    Image(systemName: "person")
//                                    Text("Setting")
//                                }
//                                .tag(3)
                        }
                        .accentColor(ThemeManager.themeColors[isThemeGroupButton].tabBarTintColor)
                    } else {
                        if authViewModel.hasAccount {
                            LoadingView(text: "포스티 시작하는 중")
                        } else {
                            NicknameView()
                        }
                    }
                } else {
                    LoginView()
                }
            } else {
                SplashScreenView()
            }
        }
        .alert("업데이트 알림", isPresented: $showUpdate) {
//                    Button("나중에") {}
            let appleID = 6478052812 //테스트용 멜론 앱으로 연결: 415597317
            if let url = URL(string: "itms-apps://itunes.apple.com/app/apple-store/\(appleID)") {
                Link("업데이트", destination: url)
            }
        } message: {
            Text("새로운 버전 업데이트가 있어요! 더 나은 서비스를 위해 포스티를 업데이트 해 주세요.")
        }
        .onAppear {
            Task {
                if await AppStoreUpdateChecker.isNewVersionAvailable() {
                    showUpdate = true
                    print("신규 버전 있음, alert 띄우자")
                } else {
                    print("신규 버전 없음")
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
