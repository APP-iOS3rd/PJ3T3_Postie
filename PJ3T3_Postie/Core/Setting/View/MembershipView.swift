//
//  MembershipView.swift
//  PJ3T3_Postie
//
//  Created by 권운기 on 2/7/24.
//

import SwiftUI

struct MembershipView: View {
    var body: some View {
        ZStack {
            Color.postieBeige
                .ignoresSafeArea()
            
            ScrollView {
                Text("일반 회원")
            }
        }
    }
}

#Preview {
    MembershipView()
}
