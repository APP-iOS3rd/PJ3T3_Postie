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
    @State private var todayAlert = true
    
    var body: some View {
        ZStack {
            postieColors.backGroundColor
                .ignoresSafeArea()
            
            ScrollView {
                VStack {
                    Toggle(isOn: $allAlert) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("전체 알림")
                                .foregroundStyle(postieColors.tabBarTintColor)
                            
                            Text("편지 알림을 받을 수 있습니다.")
                                .font(.footnote)
                                .foregroundColor(postieColors.dividerColor)
                        }
                    }
                    .padding(.bottom, 5)
                    
                    DividerView()
                        .padding(.bottom)
                    
                    Toggle(isOn: $slowAlert) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("옛 편지 알림")
                                .foregroundStyle(postieColors.tabBarTintColor)
                            
                            Text("N년전 오늘 적었던 편지 알림을 받을 수 있습니다.")
                                .font(.footnote)
                                .foregroundColor(postieColors.dividerColor)
                        }
                    }
                    .disabled(!allAlert)
                    .padding(.bottom)
                    
                    Toggle(isOn: $todayAlert) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("오늘의 편지 알림")
                                .foregroundStyle(postieColors.tabBarTintColor)
                            
                            Text("매일 새로운 편지 알림을 받을 수 있습니다.")
                                .font(.footnote)
                                .foregroundColor(postieColors.dividerColor)
                        }
                    }
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
