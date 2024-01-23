//
//  ProfileView.swift
//  PJ3T3_Postie
//
//  Created by 권운기 on 1/23/24.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                
                ZStack {
                    Circle()
                        .frame(width: 170,height: 170)
                    .foregroundStyle(Color.init(hex: 0xD1CEC7))
                    
                    Text("Postie")
                        .font(.title)
                        .foregroundStyle(Color.black)
                }
                
                Spacer()
            }
            
            Text("이름")
            
            Rectangle()
                .frame(height: 1)
                .padding(.bottom)
            
            Text("Postie_test")
                .padding(.bottom)
            
            Text("계정")
            
            Rectangle()
                .frame(height: 1)
                .padding(.bottom)
            
            Text("postie@test.com")
                .padding(.bottom)
            
            Text("구독정보")
            
            Rectangle()
                .frame(height: 1)
                .padding(.bottom)
            
            Text("일반회원")
                .padding(.bottom)
            
            Text("계정 관리")
            
            Rectangle()
                .frame(height: 1)
                .padding(.bottom)
            
            Text("로그아웃")
                .padding(.bottom)
            
            Text("회원탈퇴")
            
            Spacer()
        }
        .tint(Color.black)
        .padding()
    }
}

#Preview {
    ProfileView()
}
