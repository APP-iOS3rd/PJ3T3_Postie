//
//  ProfileView.swift
//  PJ3T3_Postie
//
//  Created by 권운기 on 1/23/24.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var authManager = AuthManager.shared
    
    @State private var isLogOutAlert: Bool = false
    @State private var isSignOutAlert: Bool = false
    @Binding var isThemeGroupButton: Int
    
    var body: some View {
        let postieColors = ThemeManager.themeColors[isThemeGroupButton]
        
        ZStack {
            postieColors.backGroundColor
                .ignoresSafeArea()
            
            ScrollView {
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
                    
                    Text(" Postie_test")
                        .foregroundStyle(postieColors.tabBarTintColor)
                        .padding(.bottom)
                    
                    Text("계정")
                        .foregroundStyle(postieColors.dividerColor)
                    
                    DividerView(isThemeGroupButton: $isThemeGroupButton)
                    
                    Text(" postie@test.com")
                        .foregroundStyle(postieColors.tabBarTintColor)
                        .padding(.bottom)
                    
                    Text("구독정보")
                        .foregroundStyle(postieColors.dividerColor)
                    
                    DividerView(isThemeGroupButton: $isThemeGroupButton)
                    
                    NavigationLink {
                        MembershipView()
                    } label: {
                        HStack {
                            Text(" 일반회원")
                                .foregroundStyle(postieColors.tabBarTintColor)
                                .padding(.bottom)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundStyle(postieColors.dividerColor)
                        }
                    }
                    
                    Text("계정 관리")
                        .foregroundStyle(postieColors.dividerColor)
                    
                    DividerView(isThemeGroupButton: $isThemeGroupButton)
                    
                    Button {
                        isLogOutAlert = true
                    } label: {
                        Text(" 로그아웃")
                            .foregroundStyle(postieColors.tabBarTintColor)
                            .padding(.bottom)
                    }
                    .alert("로그아웃", isPresented: $isLogOutAlert) {
                        Button(role: .cancel) {
                            
                        } label: {
                            Text("취소")
                        }
                        
                        Button(role: .destructive) {
                            authManager.signOut()
                        } label: {
                            Text("확인")
                        }
                    } message: {
                        Text("로그아웃 하시겠습니까??")
                    }
                    
                    Button {
                        isSignOutAlert = true
                    } label: {
                        Text(" 회원탈퇴")
                            .foregroundStyle(postieColors.tabBarTintColor)
                    }
                    .alert("회원탈퇴", isPresented: $isSignOutAlert) {
                        Button(role: .cancel) {
                            
                        } label: {
                            Text("취소")
                        }
                        
                        Button(role: .destructive) {
                            authManager.signOut()
                        } label: {
                            Text("확인")
                        }
                    } message: {
                        Text("회원탈퇴 하시겠습니까??")
                    }
                    
                    Spacer()
                }
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
                NavigationLink {
                    ProfileEditView(isThemeGroupButton: $isThemeGroupButton)
                } label: {
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
