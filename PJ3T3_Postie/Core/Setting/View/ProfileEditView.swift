//
//  ProfileEditView.swift
//  PJ3T3_Postie
//
//  Created by 권운기 on 2/7/24.
//

import SwiftUI

struct ProfileEditView: View {
    var body: some View {
        ZStack {
            Color.postieBeige
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading) {
                    ZStack {
                        Circle()
                            .frame(width: 170, height: 170)
                            .foregroundStyle(.postieGray)
                        
                        Image("postyReceivingBeige")
                            .resizable()
                            .frame(width: 170, height: 170)
                    }
                    
                    Text("프로필 수정뷰")
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("프로필 수정")
                    .bold()
                //                    .foregroundStyle(postieColors.tintColor)
            }
            
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    
                } label: {
                    Text("완료")
                }
            }
        }
    }
}

#Preview {
    ProfileEditView()
}
