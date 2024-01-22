//
//  ContentView.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 1/15/24.
//

import SwiftUI

struct ContentView: View {
    //ViewModels
    @ObservedObject var authViewModel = AuthViewModel.shared
    
    var body: some View {
        Group {
            //ViewModel의 userSession이 Published로 구현되어 있기 때문에 해당 뷰에 업데이트가 발생하면 ContentView에 새로운 userSession값을 가지고 뷰를 재구성하도록 신호를 보낸다.
            //ContentView는 viewModel에 업데이트가 없는지 listen하는 상태
            if authViewModel.userSession != nil {
                //userSession이 있으면 SettingView를 보여줌
                TabView {
                    HomeView()
                        .tabItem {
                            Image(systemName: "list.star")
                            Text("Data List")
                        }
                    
                    //테스트용 뷰입니다. 추후 삭제 예정입니다.
                    SettingView()
                        .tabItem {
                            Image(systemName: "person")
                            Text("Profile")
                        }
                }
            } else {
                LoginView()
            }
        }
    }
}

#Preview {
    ContentView()
}
