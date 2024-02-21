//
//  ProfileEditView.swift
//  PJ3T3_Postie
//
//  Created by 권운기 on 2/7/24.
//

import SwiftUI

struct ProfileEditView: View {
    @Environment(\.dismiss) var dismiss
    
    @AppStorage("isThemeGroupButton") private var isThemeGroupButton: Int = 0
    @Binding var profileImage: String
    @Binding var profileImageTemp: String
    
    var body: some View {
        let profileImages = ["postySmileSketch", "postySmileLine", "postySmileLineColor", "postyThinkingSketch", "postyThinkingLine", "postyThinkingLineColor", "postySendingSketch", "postySendingLine", "postySendingLineColor", "postyReceivingSketch", "postyReceivingLine", "postyReceivingLineColor", "postyHeartSketch", "postyHeartLine", "postyHeartLineColor", "postyTrumpetSketch", "postyTrumpetLine", "postyTrumpetLineColor", "postyQuestionSketch", "postyQuestionLine", "postyQuestionLineColor", "postyNormalSketch", "postyNormalLine", "postyNormalLineColor", "postyWinkSketch", "postyWinkLine", "postyWinkLineColor", "postySleepingSketch", "postySleepingLine", "postySleepingLineColor", "postyNotGoodSketch", "postyNotGoodLine", "postyNotGoodLineColor"]
        let rows3: [GridItem] = Array(repeating: .init(.fixed(180)), count: 3)
        let rows2: [GridItem] = Array(repeating: .init(.fixed(180)), count: 2)
        
        GeometryReader { geometry in
            ZStack {
                postieColors.backGroundColor
                    .ignoresSafeArea()
                
                VStack {
                    Text("프로필에 사용될 캐릭터를 선택해주세요!")
                        .bold()
                        .font(geometry.size.height < 430 ? .system(size: 18) : .title3)
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
                            profileImage = profileImageTemp
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
                        .customOnChange(profileImageTemp) { newValue in
                            saveToUserDefaults(value: newValue, key: "profileImageTemp")
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
