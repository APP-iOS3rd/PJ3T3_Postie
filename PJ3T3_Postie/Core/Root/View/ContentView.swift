//
//  ContentView.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 1/15/24.
//

import SwiftUI

//struct TestView: View {
//    var body: some View {
//        NaverMap(coord: coord)
//    }
//}

struct ContentView: View {
    //ViewModels
    @ObservedObject var authViewModel = AuthManager.shared
    @StateObject private var viewModel = AppViewModel()
    
    @AppStorage("isThemeGroupButton") private var isThemeGroupButton: Int = 0
    
    var body: some View {
        Group {
            // 로딩 끝나면 화면 재생
            if viewModel.isLoading {
                //ViewModel의 userSession이 Published로 구현되어 있기 때문에 해당 뷰에 업데이트가 발생하면 ContentView에 새로운 userSession값을 가지고 뷰를 재구성하도록 신호를 보낸다.
                // ContentView는 viewModel에 업데이트가 없는지 listen하는 상태
                if authViewModel.userSession != nil { // userSession이 있으면 SettingView를 보여줌
                    if authViewModel.currentUser != nil {
                        TabView {
                            HomeView(isThemeGroupButton: $isThemeGroupButton)
                                .tabItem {
                                    Image(systemName: "house")
                                    Text("Home")
                                }
                            
                            ShopView(isThemeGroupButton: $isThemeGroupButton)
                                .tabItem {
                                    Image(systemName: "cart")
                                    Text("Letter Paper")
                                }
                            
                            MapView()
                                .tabItem {
                                    Image(systemName: "map")
                                    Text("Map")
                                }
                            
                            //테스트용 뷰입니다. 추후 삭제 예정입니다.
                            SettingView()
                                .tabItem {
                                    Image(systemName: "person")
                                    Text("Setting")
                                }
                        }
                    } else {
                        if authViewModel.hasAccount {
                            ProgressView()
                        } else {
                            NicknameView()
                        }
                    }
                } else {
                    LoginView()
                }
            } else {
                SplashScreenView(isThemeGroupButton: $isThemeGroupButton)
            }
        }
    }
}

#Preview {
    ContentView()
}
