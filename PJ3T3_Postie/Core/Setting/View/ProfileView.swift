//
//  ProfileView.swift
//  PJ3T3_Postie
//
//  Created by 권운기 on 1/23/24.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var authManager = AuthManager.shared
    
    @Binding var isThemeGroupButton: Int
    
    var body: some View {
        let postieColors = ThemeManager.themeColors[isThemeGroupButton]
        
        ZStack {
            postieColors.backGroundColor
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                    
                    ZStack {
                        Circle()
                            .frame(width: 170, height: 170)
                            .foregroundStyle(postieColors.profileColor)
                        
                        Image("postyReceivingBeige")
                            .resizable()
                            .frame(width: 170, height: 170)
                    }
                    
                    Spacer()
                }
                
                Text("이름")
                    .foregroundStyle(postieColors.dividerColor)
                
                DividerView(isThemeGroupButton: $isThemeGroupButton)
                
                Text("Postie_test")
                    .foregroundStyle(postieColors.tabBarTintColor)
                    .font(.title3)
                    .padding(.bottom)
                
                Text("계정")
                    .foregroundStyle(postieColors.dividerColor)
                
                DividerView(isThemeGroupButton: $isThemeGroupButton)
                
                Text("postie@test.com")
                    .foregroundStyle(postieColors.tabBarTintColor)
                    .font(.title3)
                    .padding(.bottom)
                
                Text("구독정보")
                    .foregroundStyle(postieColors.dividerColor)
                
                DividerView(isThemeGroupButton: $isThemeGroupButton)
                
                Text("일반회원")
                    .foregroundStyle(postieColors.tabBarTintColor)
                    .font(.title3)
                    .padding(.bottom)
                
                Text("계정 관리")
                    .foregroundStyle(postieColors.dividerColor)
                
                DividerView(isThemeGroupButton: $isThemeGroupButton)
                
                Button {
                    authManager.signOut()
                } label: {
                    Text("로그아웃")
                        .foregroundStyle(postieColors.tabBarTintColor)
                        .font(.title3)
                        .padding(.bottom)
                }
                
                Text("회원탈퇴")
                    .foregroundStyle(postieColors.tabBarTintColor)
                    .font(.title3)
                
                Spacer()
            }
            .tint(postieColors.tabBarTintColor)
            .padding()
        }
        .toolbar {
            ToolbarItemGroup(placement: .principal) {
                Text("프로필 설정")
                    .bold()
                    .foregroundStyle(postieColors.tintColor)
            }
            
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button(action: {
                }) {
                    Text("수정")
                        .foregroundStyle(postieColors.tabBarTintColor)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .tint(postieColors.tabBarTintColor)
    }
}

//#Preview {
//    ProfileView()
//}
