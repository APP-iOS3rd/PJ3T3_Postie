//
//  ProfileEditView.swift
//  PJ3T3_Postie
//
//  Created by 권운기 on 2/7/24.
//

import SwiftUI

struct ProfileEditView: View {
    @ObservedObject var authManager = AuthManager.shared
    @Environment(\.dismiss) var dismiss
    
    @State var name: String = " postieTest"
    @State private var isShowingProfileImageEditor = false
    @Binding var isThemeGroupButton: Int
    
    var body: some View {
        let postieColors = ThemeManager.themeColors[isThemeGroupButton]
        
        ZStack {
            postieColors.backGroundColor
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                    
                    Button (action: {
                        isShowingProfileImageEditor = true
                    }) {
                        ZStack {
                            Circle()
                                .frame(width: 170, height: 170)
                                .foregroundStyle(.postieGray)
                            
                            Image("postyReceivingBeige")
                                .resizable()
                                .frame(width: 170, height: 170)
                            
                            Image(systemName: "plus.circle")
                                .font(.title)
                                .foregroundColor(postieColors.tabBarTintColor)
                                .offset(x: 60, y: 60)
                        }
                    }
                    .sheet(isPresented: $isShowingProfileImageEditor) {
                        ProfileImageEditView(isThemeGroupButton: $isThemeGroupButton)
                            .presentationDetents([.medium])
                    }
                    
                    Spacer()
                }
                
                Text("이름")
                    .foregroundStyle(postieColors.dividerColor)
                
                DividerView(isThemeGroupButton: $isThemeGroupButton)
                
                TextField(" 닉네임을 입력하세요", text: $name)
                    .padding(.bottom)
                    .textFieldStyle(.roundedBorder)
                
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        ZStack {
                            Rectangle()
                                .frame(height: 50)
                                .cornerRadius(20)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .foregroundStyle(postieColors.receivedLetterColor)
                                )
                            
                            Text("취소")
                                .foregroundStyle(postieColors.tabBarTintColor)
                                .padding()
                        }
                    }
                    
                    Button(action: {
                        dismiss()
                    }) {
                        ZStack {
                            Rectangle()
                                .frame(height: 50)
                                .cornerRadius(20)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .foregroundStyle(postieColors.tintColor)
                                )
                            
                            Text("저장")
                                .foregroundStyle(isThemeGroupButton == 4 ? .postieBlack : .postieWhite)
                                .padding()
                        }
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("프로필 수정")
                    .bold()
                    .foregroundStyle(postieColors.tintColor)
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    dismiss()
                } label: {
                    Text("완료")
                        .foregroundStyle(postieColors.tabBarTintColor)
                }
            }
        }
    }
}

struct ProfileImageEditView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var isThemeGroupButton: Int
    
    var body: some View {
        let postieColors = ThemeManager.themeColors[isThemeGroupButton]
        
        VStack {
            Text("나만의 프로필을 설정해보세요")
                .foregroundStyle(postieColors.tabBarTintColor)
            
            ScrollView(.horizontal) {
                HStack {
                    ZStack {
                        Circle()
                            .frame(width: 170, height: 170)
                            .foregroundStyle(postieColors.profileColor)
                        
                        Image("postyReceivingBeige")
                            .resizable()
                            .frame(width: 170, height: 170)
                    }
                    ZStack {
                        Circle()
                            .frame(width: 170, height: 170)
                            .foregroundStyle(postieColors.profileColor)
                        
                        Image("postySmile")
                            .resizable()
                            .frame(width: 100, height: 100)
                    }
                    ZStack {
                        Circle()
                            .frame(width: 170, height: 170)
                            .foregroundStyle(postieColors.profileColor)
                        
                        Image("postySending")
                            .resizable()
                            .frame(width: 150, height: 150)
                    }
                    ZStack {
                        Circle()
                            .frame(width: 170, height: 170)
                            .foregroundStyle(postieColors.profileColor)
                        
                        Image("postyReceiving")
                            .resizable()
                            .frame(width: 100, height: 100)
                    }
                    ZStack {
                        Circle()
                            .frame(width: 170, height: 170)
                            .foregroundStyle(postieColors.profileColor)
                        
                        Image("postyTrumpet")
                            .resizable()
                            .frame(width: 100, height: 100)
                    }
                    ZStack {
                        Circle()
                            .frame(width: 170, height: 170)
                            .foregroundStyle(postieColors.profileColor)
                        
                        Image("postyThinking")
                            .resizable()
                            .frame(width: 100, height: 100)
                    }
                }
                .padding()
            }
            
            HStack {
                Text("닫기")
                
                Text("저장")
            }
        }
    }
}

//#Preview {
//    ProfileEditView()
//}
