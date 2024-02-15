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
    
    @AppStorage("isThemeGroupButton") private var isThemeGroupButton: Int = 0
    @State var name: String = "테스트 포스티"
    @State private var isShowingProfileImageEditor = false
    @Binding var profileImage: String
    @Binding var profileImageTemp: String
    
    var body: some View {
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
                                    .frame(width: geometry.size.height < 400 ? 80 : 110, height: geometry.size.height < 400 ? 80 : 110)
                                    .offset(y: -10)
                                
                                Image(systemName: "pencil.circle.fill")
                                    .font(geometry.size.height < 400 ? .title3 : .title2)
                                    .foregroundColor(postieColors.tabBarTintColor)
                                    .offset(x: geometry.size.height < 400 ? 50 : 60, y: geometry.size.height < 400 ? 50 : 60)
                            }
                        }
                        .sheet(isPresented: $isShowingProfileImageEditor) {
                            ProfileImageEditView(profileImage: $profileImage, profileImageTemp: $profileImageTemp)
                                .presentationDetents([.medium, .large])
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
                            profileImage = profileImageTemp
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
    
    @AppStorage("isThemeGroupButton") private var isThemeGroupButton: Int = 0
    @Binding var profileImage: String
    @Binding var profileImageTemp: String
    
    var body: some View {
        let profileImages = ["postySmileSketch", "postySmileLine", "postySmileLineColor", "postyThinkingSketch", "postyThinkingLine", "postyThinkingLineColor", "postySendingSketch", "postySendingLine", "postySendingLineColor", "postyReceivingSketch", "postyReceivingLine", "postyReceivingLineColor", "postyHeartSketch", "postyHeartLine", "postyHeartLineColor", "postyTrumpetSketch", "postyTrumpetLine", "postyTrumpetLineColor", "postyQuestionSketch", "postyQuestionLine", "postyQuestionLineColor", "postyNormalSketch", "postyNormalLine", "postyNormalLineColor", "postyWinkSketch", "postyWinkLine", "postyWinkLineColor", "postySleepingSketch", "postySleepingLine", "postySleepingLineColor", "postyNotGoodSketch", "postyNotGoodLine", "postyNotGoodLineColor"]
        let rows3: [GridItem] = Array(repeating: .init(.fixed(170)), count: 3)
        let rows2: [GridItem] = Array(repeating: .init(.fixed(170)), count: 2)
        
        GeometryReader { geometry in
            ZStack {
                postieColors.backGroundColor
                    .ignoresSafeArea()
                
                VStack {
                    Text("프로필에 사용될 캐릭터를 선택해주세요!")
                        .bold()
                        .font(.title3)
                        .foregroundStyle(postieColors.tabBarTintColor)
                        .padding()
                    
                    Spacer()
                    ScrollView(.horizontal) {
                        if geometry.size.height > 710 {
                            LazyHGrid(rows: rows3, alignment: .top) {
                                ForEach(profileImages, id: \.self) { imageName in
                                    ProfileImageItemView(imageName: imageName, profileImageTemp: $profileImageTemp)
                                }
                            }
                        } else if geometry.size.height > 600 && geometry.size.height < 800  {
                            LazyHGrid(rows: rows2, alignment: .top) {
                                ForEach(profileImages, id: \.self) { imageName in
                                    ProfileImageItemView(imageName: imageName, profileImageTemp: $profileImageTemp)
                                }
                            }
                        } else {
                            HStack {
                                ForEach(profileImages, id: \.self) { imageName in
                                    ProfileImageItemView(imageName: imageName, profileImageTemp: $profileImageTemp)
                                }
                            }
                            .onChange(of: profileImageTemp) { newValue in
                                saveToUserDefaults(value: newValue, key: "profileImageTemp")
                            }
                            .padding()
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
}

struct ProfileImageItemView: View {
    let imageName: String
    
    @AppStorage("isThemeGroupButton") private var isThemeGroupButton: Int = 0
    @Binding var profileImageTemp: String
    
    var body: some View {
        Button(action: {
            profileImageTemp = imageName
        }) {
            ZStack {
                Circle()
                    .frame(width: 172, height: 172)
                    .foregroundStyle(profileImageTemp == imageName ? postieColors.tintColor : postieColors.tintColor.opacity(0))
                
                Circle()
                    .frame(width: 170, height: 170)
                    .foregroundStyle(postieColors.profileColor)
                
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
            }
        }
    }
}

//#Preview {
//    ProfileEditView()
//}
