//
//  SplashScreenView.swift
//  PJ3T3_Postie
//
//  Created by 권운기 on 2/4/24.
//

import SwiftUI

struct SplashScreenView: View {
    @AppStorage("isThemeGroupButton") private var isThemeGroupButton: Int = 0
    
    var body: some View {
        let random_number = Int.random(in: 1...5)
        
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
                
                Text("내 손안의 편지 보관함")
                    .foregroundStyle(postieColors.dividerColor)
                
                Text("언제 어디서나")
                    .foregroundStyle(postieColors.dividerColor)
                
                if random_number == 1 {
                    Image("postyReceivingLineColor")
                        .resizable()
                        .frame(width: 300, height: 300)
                } else if random_number == 2 {
                    Image("postySendingLineColor")
                        .resizable()
                        .frame(width: 300, height: 300)
                } else if random_number == 3 {
                    Image("postySmileLineColor")
                        .resizable()
                        .frame(width: 300, height: 300)
                } else if random_number == 4 {
                    Image("postyTrumpetLineColor")
                        .resizable()
                        .frame(width: 300, height: 300)
                } else {
                    Image("postyHeartLineColor")
                        .resizable()
                        .frame(width: 300, height: 300)
                }
                
                ProgressView()
                    .offset(y: -40)
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
