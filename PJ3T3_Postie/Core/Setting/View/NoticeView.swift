//
//  NoticeView.swift
//  PJ3T3_Postie
//
//  Created by 권운기 on 2/11/24.
//

import SwiftUI

struct NoticeView: View {
    @Binding var isThemeGroupButton: Int
    
    var body: some View {
        let postieColors = ThemeManager.themeColors[isThemeGroupButton]
        
        ZStack {
            postieColors.backGroundColor
                .ignoresSafeArea()
            
            ScrollView {
                Text("Hello, World!")
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .principal) {
                Text("공지사항")
                    .bold()
                    .foregroundStyle(postieColors.tintColor)
            }
        }
        .toolbarBackground(postieColors.backGroundColor, for: .navigationBar)
        .navigationBarTitleDisplayMode(.inline)
    }
}

//#Preview {
//    NoticeView()
//}
