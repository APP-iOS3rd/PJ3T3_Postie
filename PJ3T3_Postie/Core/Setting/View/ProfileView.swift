//
//  ProfileView.swift
//  PJ3T3_Postie
//
//  Created by 권운기 on 1/23/24.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var authManager = AuthManager.shared
    
    @AppStorage("isThemeGroupButton") private var isThemeGroupButton: Int = 0
    @State private var isLogOutAlert: Bool = false
    @State private var isSignOutAlert: Bool = false
    @State private var isshowingMembershipView = false
    @State private var isShowingProfileEditView = false
    @Binding var profileImage: String
    @Binding var profileImageTemp: String
    
    var body: some View {
        let user = authManager.currentUser
        
        GeometryReader { geometry in
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
                                
                                Image(profileImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 110, height: 110)
                                    .offset(y: -15)
                            }
                            
                            Spacer()
                        }
                        
                        Text("이름")
                            .font(.subheadline)
                            .foregroundStyle(postieColors.dividerColor)
                        
                        DividerView()
                            .padding(.bottom)
                        
                        Text(" \(String(user?.fullName ?? ""))")
                            .foregroundStyle(postieColors.tabBarTintColor)
                            .padding(.bottom)
                        
                        Text("닉네임")
                            .font(.subheadline)
                            .foregroundStyle(postieColors.dividerColor)
                        
                        DividerView()
                            .padding(.bottom)
                        
                        Text(" \(String(user?.nickname ?? ""))")
                            .foregroundStyle(postieColors.tabBarTintColor)
                            .padding(.bottom)
                        
                        Text("계정")
                            .font(.subheadline)
                            .foregroundStyle(postieColors.dividerColor)
                        
                        DividerView()
                            .padding(.bottom)
                        
                        Text(" \(String(user?.email ?? ""))")
                            .foregroundStyle(postieColors.tabBarTintColor)
                            .padding(.bottom)
                        
                        Text("구독정보")
                            .font(.subheadline)
                            .foregroundStyle(postieColors.dividerColor)
                        
                        DividerView()
                            .padding(.bottom)
                        
                        Button {
                            isshowingMembershipView = true
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
                        .fullScreenCover(isPresented: $isshowingMembershipView) {
                            // 멤버십 뷰, 실제 배포시에는 사라질 수도 있음
                            MembershipView()
                        }
                        
                        Text("계정 관리")
                            .font(.subheadline)
                            .foregroundStyle(postieColors.dividerColor)
                        
                        DividerView()
                            .padding(.bottom)
                        
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
                    .padding()
                }
                .tint(postieColors.tabBarTintColor)
            }
            .toolbar {
                ToolbarItemGroup(placement: .principal) {
                    Text("프로필 설정")
                        .bold()
                        .foregroundStyle(postieColors.tintColor)
                }
                
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button (action: {
                        isShowingProfileEditView = true
                    }) {
                        Text("수정")
                            .foregroundStyle(postieColors.tabBarTintColor)
                    }
                    .sheet(isPresented: $isShowingProfileEditView) {
                        ProfileEditView(profileImage: $profileImage, profileImageTemp: $profileImageTemp)
                            .presentationDetents([.medium])
                    }
                }
            }
            .toolbarBackground(postieColors.backGroundColor, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
            .tint(postieColors.tabBarTintColor)
        }
    }
}

//#Preview {
//    ProfileView()
//}
