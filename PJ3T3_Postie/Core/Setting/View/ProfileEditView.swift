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
    
    @State var name: String = "테스트 포스티"
    @State private var isShowingProfileImageEditor = false
    @Binding var isThemeGroupButton: Int
    @Binding var profileImage: String
    @Binding var profileImageTemp: String
    
    var body: some View {
        let postieColors = ThemeManager.themeColors[isThemeGroupButton]
        
        GeometryReader { geometry in
            ZStack {
                postieColors.backGroundColor
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    Text("나만의 프로필을 설정해보세요!")
                        .bold()
                        .font(geometry.size.height < 400 ? .title3 : .title2)
                        .foregroundStyle(postieColors.tabBarTintColor)
                    
                    Spacer()
                    
                    HStack {
                        Button (action: {
                            isShowingProfileImageEditor = true
                        }) {
                            ZStack {
                                Circle()
                                    .frame(width: geometry.size.height < 400 ? 140 : 170, height: geometry.size.height < 400 ? 140 : 170)
                                    .foregroundStyle(.postieGray)
                                
                                Image(profileImageTemp)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: geometry.size.height < 400 ? 140 : 170, height: geometry.size.height < 400 ? 140 : 170)
                                    .clipShape(Circle())
                                
                                Image(systemName: "pencil.circle.fill")
                                    .font(geometry.size.height < 400 ? .title3 : .title2)
                                    .foregroundColor(postieColors.tabBarTintColor)
                                    .offset(x: geometry.size.height < 400 ? 50 : 60, y: geometry.size.height < 400 ? 50 : 60)
                            }
                        }
                        .sheet(isPresented: $isShowingProfileImageEditor) {
                            ProfileImageEditView(isThemeGroupButton: $isThemeGroupButton, profileImage: $profileImage, profileImageTemp: $profileImageTemp)
                                .presentationDetents([.medium])
                        }
                    }
                    
                    Spacer()
                    
                    HStack {
                        Text("닉네임")
                            .foregroundStyle(postieColors.dividerColor)
                        
                        Spacer()
                    }
                    .padding(.bottom, geometry.size.height < 400 ? 8 : 10)
                    
                    Rectangle()
                        .fill(postieColors.dividerColor)
                        .frame(height: 1)
                        .padding(.bottom, geometry.size.height < 400 ? 8 : 10)
                    
                    TextField(" 닉네임을 입력해주세요! (12자 제한)", text: $name)
                        .textFieldStyle(.roundedBorder)
                        .overlay(
                            HStack {
                                Spacer()
                                if !name.isEmpty {
                                    Button(action: {
                                        self.name = ""
                                    }) {
                                        Image(systemName: "multiply.circle.fill")
                                            .foregroundColor(.postieGray)
                                    }
                                    .padding(.trailing, 5)
                                }
                            }
                        )
                        .onChange(of: name) { newValue in
                            if newValue.count > 12 {
                                name = String(newValue.prefix(15))
                            }
                        }
                    
                    Spacer()
                    
                    HStack {
                        Button(action: {
                            profileImageTemp = profileImage
                            dismiss()
                        }) {
                            ZStack {
                                Rectangle()
                                    .frame(height: geometry.size.height < 400 ? 40 : 50)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .foregroundStyle(postieColors.receivedLetterColor)
                                    )
                                
                                Text("취소")
                                    .foregroundStyle(postieColors.tabBarTintColor)
                                    .padding()
                            }
                        }
                        
                        Button(action: {
                            profileImage = profileImageTemp
                            dismiss()
                        }) {
                            ZStack {
                                Rectangle()
                                    .frame(height: geometry.size.height < 400 ? 40 : 50)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .foregroundStyle(postieColors.tintColor)
                                    )
                                
                                Text("저장")
                                    .foregroundStyle(isThemeGroupButton == 4 ? .postieBlack : .postieWhite)
                                    .bold()
                                    .padding()
                            }
                        }
                        .onChange(of: profileImage) { newValue in
                            saveToUserDefaults(value: newValue, key: "profileImage")
                        }
                    }
                }
                .padding()
            }
        }
    }
}

struct ProfileImageEditView: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var isThemeGroupButton: Int
    @Binding var profileImage: String
    @Binding var profileImageTemp: String
    
    var body: some View {
        let postieColors = ThemeManager.themeColors[isThemeGroupButton]
        
        ZStack {
            postieColors.backGroundColor
                .ignoresSafeArea()
            
            VStack {
                Text("프로필에 사용될 캐릭터를 선택해주세요!")
                    .bold()
                    .font(.title2)
                    .foregroundStyle(postieColors.tabBarTintColor)
                
                Spacer()
                
                ScrollView(.horizontal) {
                    HStack {
                        Button (action: {
                            profileImageTemp = "postyReceivingBeige"
                        }) {
                            ZStack {
                                Circle()
                                    .frame(width: 172, height: 172)
                                    .foregroundStyle(profileImageTemp == "postyReceivingBeige" ? postieColors.tintColor : postieColors.tintColor.opacity(0))
                                
                                Circle()
                                    .frame(width: 170, height: 170)
                                    .foregroundStyle(postieColors.profileColor)
                                
                                Image("postyReceivingBeige")
                                    .resizable()
                                    .frame(width: 170, height: 170)
                            }
                        }
                        
                        Button (action: {
                            profileImageTemp = "postySmile"
                        }) {
                            ZStack {
                                Circle()
                                    .frame(width: 172, height: 172)
                                    .foregroundStyle(profileImageTemp == "postySmile" ? postieColors.tintColor : postieColors.tintColor.opacity(0))
                                
                                Circle()
                                    .frame(width: 170, height: 170)
                                    .foregroundStyle(postieColors.profileColor)
                                
                                Image("postySmile")
                                    .resizable()
                                    .frame(width: 100, height: 100)
                            }
                        }
                        
                        Button (action: {
                            profileImageTemp = "postySending"
                        }) {
                            ZStack {
                                Circle()
                                    .frame(width: 172, height: 172)
                                    .foregroundStyle(profileImageTemp == "postySending" ? postieColors.tintColor : postieColors.tintColor.opacity(0))
                                
                                Circle()
                                    .frame(width: 170, height: 170)
                                    .foregroundStyle(postieColors.profileColor)
                                
                                Image("postySending")
                                    .resizable()
                                    .frame(width: 150, height: 150)
                            }
                            
                        }
                        
                        Button (action: {
                            profileImageTemp = "postyReceiving"
                        }) {
                            ZStack {
                                Circle()
                                    .frame(width: 172, height: 172)
                                    .foregroundStyle(profileImageTemp == "postyReceiving" ? postieColors.tintColor : postieColors.tintColor.opacity(0))
                                
                                Circle()
                                    .frame(width: 170, height: 170)
                                    .foregroundStyle(postieColors.profileColor)
                                
                                Image("postyReceiving")
                                    .resizable()
                                    .frame(width: 100, height: 100)
                            }
                        }
                        
                        Button (action: {
                            profileImageTemp = "postyTrumpet"
                        }) {
                            ZStack {
                                Circle()
                                    .frame(width: 172, height: 172)
                                    .foregroundStyle(profileImageTemp == "postyTrumpet" ? postieColors.tintColor : postieColors.tintColor.opacity(0))
                                
                                Circle()
                                    .frame(width: 170, height: 170)
                                    .foregroundStyle(postieColors.profileColor)
                                
                                Image("postyTrumpet")
                                    .resizable()
                                    .frame(width: 100, height: 100)
                            }
                        }
                        
                        Button (action: {
                            profileImageTemp = "postyThinking"
                        }) {
                            ZStack {
                                Circle()
                                    .frame(width: 172, height: 172)
                                    .foregroundStyle(profileImageTemp == "postyThinking" ? postieColors.tintColor : postieColors.tintColor.opacity(0))
                                
                                Circle()
                                    .frame(width: 170, height: 170)
                                    .foregroundStyle(postieColors.profileColor)
                                
                                Image("postyThinking")
                                    .resizable()
                                    .frame(width: 100, height: 100)
                            }
                        }
                    }
                    .onChange(of: profileImageTemp) { newValue in
                        saveToUserDefaults(value: newValue, key: "profileImageTemp")
                    }
                    .padding()
                }
                
                Spacer()
                
                HStack {
                    Button(action: {
                        profileImageTemp = profileImage
                        dismiss()
                    }) {
                        ZStack {
                            Rectangle()
                                .frame(height: 50)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
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
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundStyle(postieColors.tintColor)
                                )
                            
                            Text("선택")
                                .foregroundStyle(isThemeGroupButton == 4 ? .postieBlack : .postieWhite)
                                .bold()
                                .padding()
                        }
                    }
                }
            }
            .padding()
        }
    }
}

//#Preview {
//    ProfileEditView()
//}
