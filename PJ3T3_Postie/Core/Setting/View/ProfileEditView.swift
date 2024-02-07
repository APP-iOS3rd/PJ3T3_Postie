//
//  ProfileEditView.swift
//  PJ3T3_Postie
//
//  Created by 권운기 on 2/7/24.
//

import SwiftUI

struct ProfileEditView: View {
    @ObservedObject var authManager = AuthManager.shared
    
    @State var name: String = " postieTest"
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
                                .foregroundStyle(.postieGray)
                            
                            Image("postyReceivingBeige")
                                .resizable()
                                .frame(width: 170, height: 170)
                        }
                        
                        Spacer()
                    }
                    
                    Text("이름")
                        .foregroundStyle(postieColors.dividerColor)
                    
                    DividerView(isThemeGroupButton: $isThemeGroupButton)
                    
                    TextField(" 닉네임을 입력하세요", text: $name)
                        .padding(.bottom)
                    
                    Text("계정 설정")
                        .foregroundStyle(postieColors.dividerColor)
                    
                    DividerView(isThemeGroupButton: $isThemeGroupButton)
                    
                    HStack {
                        Text(" postie@test.com")
                            .foregroundStyle(postieColors.tabBarTintColor)
                        
                        Spacer()
                        
                        Image(systemName: "apple.logo")
                    }
                }
            }
            .padding()
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("프로필 수정")
                    .bold()
                    .foregroundStyle(postieColors.tintColor)
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    
                } label: {
                    Text("완료")
                        .foregroundStyle(postieColors.tabBarTintColor)
                }
            }
        }
    }
}

//#Preview {
//    ProfileEditView()
//}
