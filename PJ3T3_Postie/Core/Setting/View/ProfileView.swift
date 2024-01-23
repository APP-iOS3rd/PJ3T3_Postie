//
//  ProfileView.swift
//  PJ3T3_Postie
//
//  Created by 권운기 on 1/23/24.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        ZStack {
            Color(hex: 0xF5F1E8)
                .ignoresSafeArea()
            
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
                    .foregroundStyle(Color.gray)
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(Color.gray)
                    .padding(.bottom)
                
                Text("Postie_test")
                    .font(.title3)
                    .padding(.bottom)
                
                Text("계정")
                    .foregroundStyle(Color.gray)
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(Color.gray)
                    .padding(.bottom)
                
                Text("postie@test.com")
                    .font(.title3)
                    .padding(.bottom)
                
                Text("구독정보")
                    .foregroundStyle(Color.gray)
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(Color.gray)
                    .padding(.bottom)
                
                Text("일반회원")
                    .font(.title3)
                    .padding(.bottom)
                
                Text("계정 관리")
                    .foregroundStyle(Color.gray)
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(Color.gray)
                    .padding(.bottom)
                
                Text("로그아웃")
                    .font(.title3)
                    .padding(.bottom)
                
                Text("회원탈퇴")
                    .font(.title3)
                
                Spacer()
            }
            .tint(Color.black)
            .padding()
        }
        .tint(Color.black)
        .navigationBarItems(trailing: (
                Button(action: {
                }) {
                    Text("수정")
                }
            ))
    }
}

#Preview {
    ProfileView()
}
