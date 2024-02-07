//
//  SplashScreenView.swift
//  PJ3T3_Postie
//
//  Created by 권운기 on 2/4/24.
//

import SwiftUI

struct SplashScreenView: View {
    var body: some View {
        ZStack {
            Color.postieBeige
                .ignoresSafeArea()
            
            ToFromLabelView()
                .padding()
            
            VStack {
                Text("Postie")
                    .font(.custom("SourceSerifPro-Black", size: 70))
                    .foregroundStyle(Color.postieOrange)
                    .padding()
                
                Text("내 손안의 편지 보관함")
                    .foregroundStyle(Color.postieDarkGray)
                
                Text("언제 어디서나")
                    .foregroundStyle(Color.postieDarkGray)
                
                Image("postyReceivingBeige")
                    .resizable()
                    .frame(width: 300, height: 300)
                
                ProgressView()
                    .offset(y: -40)
            }
            .padding()
        }
    }
}

struct ToFromLabelView: View {
    var body: some View {
        VStack {
            HStack {
                Text("To.")
                    .font(.custom("SourceSerifPro-Black", size: 35))
                    .foregroundStyle(Color.postieBlack)
                    .padding()
                
                Spacer()
            }
            
            Spacer()
            
            HStack {
                Spacer()
                
                Text("From.")
                    .font(.custom("SourceSerifPro-Black", size: 35))
                    .foregroundStyle(Color.postieBlack)
                    .padding()
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
