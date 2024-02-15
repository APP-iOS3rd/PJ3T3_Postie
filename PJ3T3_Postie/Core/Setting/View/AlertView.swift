//
//  AlertView.swift
//  PJ3T3_Postie
//
//  Created by 권운기 on 2/14/24.
//

import SwiftUI

struct AlertView: View {
    @AppStorage("isThemeGroupButton") private var isThemeGroupButton: Int = 0
    @State private var slowAlert = true
    @State private var allAlert = true
    @State private var alert1 = true
    @State private var alert2 = true
    
    var body: some View {
        ZStack {
            postieColors.backGroundColor
                .ignoresSafeArea()
            
            ScrollView {
                VStack {
                    Toggle("전체 알림", isOn: $allAlert)
                        .padding(.bottom)
                    
                    DividerView()
                        .padding(.bottom)
                    
                    Toggle("옛 편지 알림", isOn: $slowAlert)
                        .disabled(!allAlert)
                        .padding(.bottom)
                    
                    Toggle("오늘의 편지 알림", isOn: $alert1)
                        .disabled(!allAlert)
                }
                .padding()
            }
            .tint(isThemeGroupButton == 4 ? .postieDarkGray : postieColors.tintColor)
        }
        .toolbar {
            ToolbarItemGroup(placement: .principal) {
                Text("알림 설정")
                    .bold()
                    .foregroundStyle(postieColors.tintColor)
            }
        }
        .toolbarBackground(postieColors.backGroundColor, for: .navigationBar)
        .navigationBarTitleDisplayMode(.inline)
    }
}

//#Preview {
//    AlertView()
//}
