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
            if authViewModel.userSession != nil {
                //userSession이 있으면 SettingView를 보여줌
                SettingView()
            } else {
                LoginView()
            }
        }
    }
}

#Preview {
    ContentView()
}
