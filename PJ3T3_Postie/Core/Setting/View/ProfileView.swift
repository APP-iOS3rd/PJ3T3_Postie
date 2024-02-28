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
    @State private var isDeleteAccountDialogPresented = false
    @State private var showLoading = false
    @State private var showAlert = false
    @State private var alertBody = ""
    @Binding var profileImage: String
    @Binding var profileImageTemp: String
    
    var body: some View {
        let user = authManager.currentUser
        
        GeometryReader { geometry in
            ZStack {
                postieColors.backGroundColor
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 5) {
                        Button (action: {
                            isShowingProfileEditView = true
                            profileImageTemp = profileImage
                        }) {
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
                                        .offset(y: -10)
                                    
                                    Image(systemName: "pencil.circle.fill")
                                        .font(.title)
                                        .offset(x: 60, y: 60)
                                }
                                
                                Spacer()
                            }
                        }
                        .sheet(isPresented: $isShowingProfileEditView) {
                            ProfileEditView(profileImage: $profileImage, profileImageTemp: $profileImageTemp)
                                .presentationDetents([.medium, .large])
                        }
                        
                        Text("이름")
                            .font(.subheadline)
                            .foregroundStyle(postieColors.tintColor)
                            .padding(.leading, 3)
                        
                        DividerView()
                            .padding(.bottom, 3)
                        
                        Text(String(user?.fullName ?? ""))
                            .foregroundStyle(postieColors.tabBarTintColor)
                            .padding(.bottom)
                            .padding(.leading, 3)
                        
                        Text("닉네임")
                            .font(.subheadline)
                            .foregroundStyle(postieColors.tintColor)
                            .padding(.leading, 3)
                        
                        DividerView()
                            .padding(.bottom, 3)
                        
                        Text(String(user?.nickname ?? ""))
                            .foregroundStyle(postieColors.tabBarTintColor)
                            .padding(.bottom)
                            .padding(.leading, 3)
                        
                        Text("계정")
                            .font(.subheadline)
                            .foregroundStyle(postieColors.tintColor)
                            .padding(.leading, 3)
                        
                        DividerView()
                            .padding(.bottom, 3)
                        
                        Text(String(user?.email ?? ""))
                            .foregroundStyle(postieColors.tabBarTintColor)
                            .padding(.bottom)
                            .padding(.leading, 3)
                        
//                        Text("구독정보")
//                            .font(.subheadline)
//                            .foregroundStyle(postieColors.tintColor)
//                            .padding(.leading, 3)
//                        
//                        DividerView()
//                            .padding(.bottom, 3)
//                        
//                        Button {
//                            isshowingMembershipView = true
//                        } label: {
//                            HStack {
//                                Text("일반회원")
//                                    .foregroundStyle(postieColors.tabBarTintColor)
//                                    .padding(.bottom)
//                                    .padding(.leading, 3)
//                                
//                                Spacer()
//                                
//                                Image(systemName: "chevron.right")
//                                    .foregroundStyle(postieColors.dividerColor)
//                            }
//                        }
//                        .fullScreenCover(isPresented: $isshowingMembershipView) {
//                            // 멤버십 뷰, 실제 배포시에는 사라질 수도 있음
//                            MembershipView()
//                        }
//                        
                        Text("계정 관리")
                            .font(.subheadline)
                            .foregroundStyle(postieColors.tintColor)
                            .padding(.leading, 3)
                        
                        DividerView()
                            .padding(.bottom, 3)
                        
                        Button {
                            isLogOutAlert = true
                        } label: {
                            Text("로그아웃")
                                .foregroundStyle(postieColors.tabBarTintColor)
                                .padding(.bottom, 15)
                                .padding(.leading, 3)
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
                            Text("로그아웃 하시겠습니까?")
                        }
                        
                        Button {
                            isSignOutAlert = true
                        } label: {
                            Text("회원 탈퇴")
                                .foregroundStyle(postieColors.dividerColor)
                                .padding(.leading, 3)
                        }
                        .alert("회원 탈퇴", isPresented: $isSignOutAlert) {
                            Button(role: .cancel) {
                                
                            } label: {
                                Text("취소")
                            }
                            
                            Button(role: .destructive) {
                                isDeleteAccountDialogPresented = true
                            } label: {
                                Text("확인")
                            }
                        } message: {
                            Text("회원 탈퇴 하시겠습니까?")
                        }
                        .alert(isPresented: $showAlert) {
                            let title = Text("탈퇴 실패")
                            let message = Text(alertBody)
                            let confirmButton = Alert.Button.cancel(Text("확인"))

                            return Alert(title: title, message: message, dismissButton: confirmButton)
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
            }
            .toolbarBackground(postieColors.backGroundColor, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
            .tint(postieColors.tabBarTintColor)
            .confirmationDialog("포스티를 떠나시나요?", isPresented: $isDeleteAccountDialogPresented, titleVisibility: .visible) {
                DeleteAccountButtonView(showLoading: $showLoading, showAlert: $showAlert, alertBody: $alertBody)
            } message: {
                Text("회원 탈퇴 시에는 계정과 프로필 정보, 그리고 등록된 모든 편지와 편지 이미지가 삭제되며 복구할 수 없습니다.\n계정 삭제를 위해서는 재인증을 통해 다시 로그인 해야 합니다.")
            }
            .fullScreenCover(isPresented: $showLoading) {
                LoadingView(text: "저장된 편지들을 안전하게 삭제하는 중이에요")
                    .background(ClearBackground())
            }
        }
    }
}

//#Preview {
//    ProfileView()
//}
