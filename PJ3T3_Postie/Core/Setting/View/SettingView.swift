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
    //ViewModels
    @ObservedObject var authViewModel = AuthViewModel.shared
    @ObservedObject var firestoreManager = FirestoreManager.shared //테스트용으로 vm 임시 선언, 삭제 예정
    
    var body: some View {
        NavigationStack {
            if let user = authViewModel.currentUser {
                List {
                    Section {
                        HStack {
                            Text(user.initials)
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                                .frame(width: 72, height: 72)
                                .background(profileBackgroundColor)
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(user.fullName)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .padding(.top, 4)
                                
                                Text(user.email)
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
                            authViewModel.signOut()
                        } label: {
                            SettingsRowView(imageName: "arrow.left.circle.fill", title: "Sign Out", tintColor: signOutIconColor)
                        }
                        
                        Button {
                            print("Delete account")
                        } label: {
                            SettingsRowView(imageName: "xmark.circle.fill", title: "Delete Account", tintColor: signOutIconColor)
                        }
                    } //Section
                    
                    Section("Data Test") {
                        Button {
                            firestoreManager.addLetter(writer: "me", recipient: "you", summary: "hellooo", date: Date())
                            firestoreManager.fetchAllLetters()
                        } label: {
                            Text("Add")
                        }
                    } //Section: Home뷰에서 기능 되는 것 확인 후 삭제 예정
                    
                    ForEach(firestoreManager.letters, id: \.self) { letter in
                        VStack {
                            HStack {
                                Text("To: \(letter.recipient)")
                                
                                Spacer()
                            } //HStack
                            
                            Text("\(letter.summary)")
                            
                            HStack {
                                Spacer()
                                
                                Text("From: \(letter.writer)")
                            } //HStack
                        } //VStack
                    } //ForEach: Home뷰에서 기능 되는 것 확인 후 삭제 예정
                } //List
                .navigationTitle("Setting")
                .onAppear {
                    firestoreManager.fetchAllLetters()
                } //Home뷰에서 기능 되는 것 확인 후 onAppear삭제 예정
            } else {
                ProgressView()
            } //if...else
        } //NavigationStack
    }
}

#Preview {
    SettingView()
}
