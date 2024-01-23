//
//  SettingView.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 1/17/24.
//

import SwiftUI
import PhotosUI //Storage test를 위한 import로 이후 삭제 예정

struct SettingView: View {
    @ObservedObject var authViewModel = AuthViewModel.shared
    @ObservedObject var storageManager = StorageManager.shared
    //Colors
    private let profileBackgroundColor: Color = .gray
    private let signOutIconColor: Color = Color(uiColor: .lightGray)
    
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
                    
                    AddDataSectionView()
                    
                    LetterDataListView()
                    
                } //List
                .navigationTitle("Setting")
            } else {
                ProgressView() //로그인 중
            } //if...else
        } //NavigationStack
    }
    
    //AddLetterView에서 생성된 AddLetterViewModel을 SettingView에서 받을 수 없어 임시로 FirestoreManager에 함수 생성
    //SettingView에서 Image 저장 관련 기능 삭제할 때 해당 함수를 AddLetterViewModel로 옮길 예정
    func saveImage(item: PhotosPickerItem) {
        Task {
            //지정한 타입의 인스턴스를 불러오려고 시도한다. 실패 action 구현 필요
            guard let data = try await item.loadTransferable(type: Data.self) else { return }
            //userUid를 AuthViewModel에서 가져오도록 리팩토링 필요
            //리팩토링 하면서 파일 이름도 함께 변경 AuthViewModel -> AuthManager
            let (_, name) = try await storageManager.saveImage(data: data, userId: firestoreManager.userUid)
            selectedItemName = name
//            print("SUCCESS")
        }
    }
}

struct selectedLetterView: View {
    var letter: Letter
    @ObservedObject var storageManager = StorageManager.shared
    @ObservedObject var firestoreManager = FirestoreManager.shared
    
    var body: some View {
        VStack {
            if let retrieveImage = storageManager.retrieveImage {
                Image(uiImage: retrieveImage)
                    .resizable()
                    .frame(width: 100, height: 100)
                    .scaledToFit()
            } else {
                ProgressView()
            }
        }
        .onAppear {
            storageManager.fetchImage(userId: firestoreManager.userUid, imageName: letter.imageName ?? "")
        }
        .onDisappear {
            //뷰가 사라질 때 storageManager의 retrieveImage를 nil로 만든다.
            //nil로 만들어주지 않으면 리스트의 다른 항목을 선택했을 때 이전에 retrieveImage에 저장되어 있던 이미지가 보여지는 이슈가 있다.
            storageManager.dismissImage()
        }
    }
}

#Preview {
    SettingView()
}
