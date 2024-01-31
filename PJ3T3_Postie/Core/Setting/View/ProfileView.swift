//
//  ProfileView.swift
//  PJ3T3_Postie
//
//  Created by 권운기 on 1/23/24.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var authViewModel = AuthManager.shared
    
    var body: some View {
        ZStack {
            Color(hex: 0xF5F1E8)
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                    
                    ZStack {
                        Circle()
                            .frame(width: 170, height: 170)
                            .foregroundStyle(Color.init(hex: 0xE6E2DC))
                        
                        Image("Posty_Receiving")
                            .resizable()
                            .frame(width: 170, height: 170)
                            .offset(x: -8, y: 5)
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
                
                Button {
                    authViewModel.signOut()
                } label: {
                    Text("로그아웃")
                        .font(.title3)
                        .padding(.bottom)
                }
                
                Text("회원탈퇴")
                    .font(.title3)
                
                Spacer()
            }
            .tint(Color(hex: 0x1E1E1E))
            .padding()
        }
        .navigationTitle("프로필 설정")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: (
                Button(action: {
                }) {
                    Text("수정")
                }
            ))
        .tint(Color(hex: 0x1E1E1E))
    }
}

#Preview {
    ProfileView()
}
