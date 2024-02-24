//
//  SplashScreenView.swift
//  PJ3T3_Postie
//
//  Created by 권운기 on 2/4/24.
//

import SwiftUI

struct SplashScreenView: View {
    @AppStorage("isThemeGroupButton") private var isThemeGroupButton: Int = 0
    @ObservedObject private var counter = Counter(interval: 1)
    
    let image = ["postyReceivingLineColor", "postySendingLineColor", "postySmileLineColor", "postyTrumpetLineColor", "postyHeartLineColor"].shuffled()
    
    var body: some View {
        ZStack {
            postieColors.backGroundColor
                .ignoresSafeArea()
            
            ToFromLabelView()
                .padding()
            
            VStack {
                Text("Postie")
                    .font(.custom("SourceSerifPro-Black", size: 70))
                    .foregroundStyle(postieColors.tintColor)
                    .padding()
                
                Text("손으로 쓴 감동")
                    .foregroundStyle(postieColors.dividerColor)
                
                Text("내 손 안의 편지 보관함")
                    .foregroundStyle(postieColors.dividerColor)
                
                Image(image[counter.value])
                    .resizable()
                    .frame(width: 250, height: 250)
                
                Rectangle()
                    .frame(height: 50)
                    .foregroundStyle(postieColors.tabBarTintColor.opacity(0))
            }
            .padding()
        }
    }
}

struct ToFromLabelView: View {
    @AppStorage("isThemeGroupButton") private var isThemeGroupButton: Int = 0
    
    var body: some View {
        VStack {
            HStack {
                Text("To.")
                    .font(.custom("SourceSerifPro-Black", size: 35))
                    .foregroundStyle(postieColors.tabBarTintColor)
                    .padding()
                
                Spacer()
            }
            
            Spacer()
            
            HStack {
                Spacer()
                
                Text("From.")
                    .font(.custom("SourceSerifPro-Black", size: 35))
                    .foregroundStyle(postieColors.tabBarTintColor)
                    .padding()
            }
        }
    }
}

//#Preview {
//    SplashScreenView()
//}
