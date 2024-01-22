//
//  SettingView.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 1/17/24.
//

import SwiftUI

struct SettingView: View {
    //Colors
    private let profileBackgroundColor: Color = .gray
    private let signOutIconColor: Color = Color(uiColor: .lightGray)
    
    var body: some View {
        List {
            Section {
                HStack {
                    Text("EJ")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .frame(width: 72, height: 72)
                        .background(profileBackgroundColor)
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Eunice Jeong")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .padding(.top, 4)
                        
                        Text("test@test.com")
                            .font(.footnote)
                            .foregroundStyle(profileBackgroundColor)
                    } //VStack
                } //HStack
            } //Section
            
            Section("General") {
                HStack {
                    SettingsRowView(imageName: "gear", title: "Version", tintColor: profileBackgroundColor)
                    
                    Spacer()
                    
                    Text("1.0.0")
                        .font(.subheadline)
                        .foregroundStyle(profileBackgroundColor)
                }
            } //Section
            
            Section("Account") {
                Button {
                    print("Sign out...")
                } label: {
                    SettingsRowView(imageName: "arrow.left.circle.fill", title: "Sign Out", tintColor: signOutIconColor)
                }
                
                Button {
                    print("Delete account")
                } label: {
                    SettingsRowView(imageName: "xmark.circle.fill", title: "Delete Account", tintColor: signOutIconColor)
                }
            } //Section
        } //List
    }
}

#Preview {
    SettingView()
}
