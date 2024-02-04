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
            
            VStack {
                HStack {
                    Text("To.")
                        .font(.custom("SourceSerifPro-Black", size: 40))
                        .foregroundStyle(Color.postieBlack)
                        .padding()
                    
                    Spacer()
                }
                
                Spacer()
                
                Text("Postie")
                    .font(.custom("SourceSerifPro-Black", size: 70))
                    .foregroundStyle(Color.postieOrange)
                    .padding()
                
                Image("postyReceiving")
                    .resizable()
                    .frame(width: 300, height: 300)
                
                ProgressView()
                
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Text("From.")
                        .font(.custom("SourceSerifPro-Black", size: 40))
                        .foregroundStyle(Color.postieBlack)
                        .padding()
                }
            }
            .padding()
        }
    }
}

#Preview {
    SplashScreenView()
}
