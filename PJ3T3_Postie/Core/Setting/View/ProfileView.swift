//
//  ProfileView.swift
//  PJ3T3_Postie
//
//  Created by 권운기 on 1/23/24.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var authViewModel = AuthManager.shared
    @Binding var isThemeGroupButton: Int
    
    var body: some View {
        ZStack {
            ThemeManager.themeColors[isThemeGroupButton].backGroundColor
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                    
                    ZStack {
                        Circle()
                            .frame(width: 170, height: 170)
                            .foregroundStyle(ThemeManager.themeColors[isThemeGroupButton].profileColor)
                        
                        Image("postyReceiving")
                            .resizable()
                            .frame(width: 170, height: 170)
                    }
                    
                    Spacer()
                }
                
                Text("이름")
                    .foregroundStyle(ThemeManager.themeColors[isThemeGroupButton].dividerColor)
                
                DividerView(isThemeGroupButton: $isThemeGroupButton)
                
                Text("Postie_test")
                    .foregroundStyle(ThemeManager.themeColors[isThemeGroupButton].tabBarTintColor)
                    .font(.title3)
                    .padding(.bottom)
                
                Text("계정")
                    .foregroundStyle(ThemeManager.themeColors[isThemeGroupButton].dividerColor)
                
                DividerView(isThemeGroupButton: $isThemeGroupButton)
                
                Text("postie@test.com")
                    .foregroundStyle(ThemeManager.themeColors[isThemeGroupButton].tabBarTintColor)
                    .font(.title3)
                    .padding(.bottom)
                
                Text("구독정보")
                    .foregroundStyle(ThemeManager.themeColors[isThemeGroupButton].dividerColor)
                
                DividerView(isThemeGroupButton: $isThemeGroupButton)
                
                Text("일반회원")
                    .foregroundStyle(ThemeManager.themeColors[isThemeGroupButton].tabBarTintColor)
                    .font(.title3)
                    .padding(.bottom)
                
                Text("계정 관리")
                    .foregroundStyle(ThemeManager.themeColors[isThemeGroupButton].dividerColor)
                
                DividerView(isThemeGroupButton: $isThemeGroupButton)
                
                Button {
                    authViewModel.signOut()
                } label: {
                    Text("로그아웃")
                        .foregroundStyle(ThemeManager.themeColors[isThemeGroupButton].tabBarTintColor)
                        .font(.title3)
                        .padding(.bottom)
                }
                
                Text("회원탈퇴")
                    .foregroundStyle(ThemeManager.themeColors[isThemeGroupButton].tabBarTintColor)
                    .font(.title3)
                
                Spacer()
            }
            .tint(ThemeManager.themeColors[isThemeGroupButton].tabBarTintColor)
            .padding()
        }
        .toolbar {
            ToolbarItemGroup(placement: .principal) {
                Text("프로필 설정")
                    .bold()
                    .foregroundStyle(ThemeManager.themeColors[isThemeGroupButton].tintColor)
            }
            
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button(action: {
                }) {
                    Text("수정")
                        .foregroundStyle(ThemeManager.themeColors[isThemeGroupButton].tabBarTintColor)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .tint(ThemeManager.themeColors[isThemeGroupButton].tabBarTintColor)
    }
}

//#Preview {
//    ProfileView()
//}
