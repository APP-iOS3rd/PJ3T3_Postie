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
                
                let imageName: String = {
                    switch random_number {
                    case 1: 
                        return "postyReceivingLineColor"
                    case 2: 
                        return "postySendingLineColor"
                    case 3: 
                        return "postySmileLineColor"
                    case 4: 
                        return "postyTrumpetLineColor"
                    default: 
                        return "postyHeartLineColor"
                    }
                }()
                
                PostyImageView(imageName: imageName)
            }
            .padding()
        }
    }
}

struct PostyImageView: View {
    let imageName: String
    
    var body: some View {
        Image(imageName)
            .resizable()
            .frame(width: 250, height: 250)
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
