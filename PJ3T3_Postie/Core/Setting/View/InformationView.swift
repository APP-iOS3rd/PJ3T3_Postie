//
//  InformationView.swift
//  PJ3T3_Postie
//
//  Created by 권운기 on 2/11/24.
//

import SwiftUI

struct InformationView: View {
    @Binding var isThemeGroupButton: Int
    
    var body: some View {
        let postieColors = ThemeManager.themeColors[isThemeGroupButton]
        
        ZStack {
            postieColors.backGroundColor
                .ignoresSafeArea()
            
            ScrollView {
                HStack {
                    Text("버전정보")
                        .foregroundStyle(postieColors.tabBarTintColor)
                    
                    Spacer()
                    
                    Text("1.0.0")
                        .foregroundStyle(postieColors.dividerColor)
                }
                
                DividerView(isThemeGroupButton: $isThemeGroupButton)
                
                HStack {
                    Text("이용약관")
                        .foregroundStyle(postieColors.tabBarTintColor)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundStyle(postieColors.dividerColor)
                }
                
                DividerView(isThemeGroupButton: $isThemeGroupButton)
                
                HStack {
                    Text("개인정보 처리방침")
                        .foregroundStyle(postieColors.tabBarTintColor)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundStyle(postieColors.dividerColor)
                }
            }
            .padding()
        }
        .toolbar {
            ToolbarItemGroup(placement: .principal) {
                Text("앱 정보")
                    .bold()
                    .foregroundStyle(postieColors.tintColor)
            }
        }
        .toolbarBackground(postieColors.backGroundColor, for: .navigationBar)
        .navigationBarTitleDisplayMode(.inline)
    }
}

//#Preview {
//    InformationView()
//}
