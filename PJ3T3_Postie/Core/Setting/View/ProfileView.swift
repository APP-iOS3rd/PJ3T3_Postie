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
            Color.postieBeige
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                    
                    ZStack {
                        Circle()
                            .frame(width: 170, height: 170)
                            .foregroundStyle(Color.postieGray)
                        
                        Image("Posty_Receiving")
                            .resizable()
                            .frame(width: 170, height: 170)
                            .offset(x: -8, y: 5)
                    }
                    
                    Spacer()
                }
                
                Text("이름")
                    .foregroundStyle(Color.postieDarkGray)
                
                DividerView()
                
                Text("Postie_test")
                    .font(.title3)
                    .padding(.bottom)
                
                Text("계정")
                    .foregroundStyle(Color.postieDarkGray)
                
                DividerView()
                
                Text("postie@test.com")
                    .font(.title3)
                    .padding(.bottom)
                
                Text("구독정보")
                    .foregroundStyle(Color.postieDarkGray)
                
                DividerView()
                
                Text("일반회원")
                    .font(.title3)
                    .padding(.bottom)
                
                Text("계정 관리")
                    .foregroundStyle(Color.postieDarkGray)
                
                DividerView()
                
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
            .tint(Color.postieBlack)
            .padding()
        }
        .toolbar {
            ToolbarItemGroup(placement: .principal) {
                Text("프로필 설정")
                    .bold()
                    .foregroundStyle(Color.postieOrange)
            }
            
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button(action: {
                }) {
                    Text("수정")
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .tint(Color.postieBlack)
    }
}

#Preview {
    ProfileView()
}
