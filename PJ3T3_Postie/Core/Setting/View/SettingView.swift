//
//  SettingView.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 1/17/24.
//

import SwiftUI
import PhotosUI //Storage test를 위한 import로 이후 삭제 예정

struct SettingView: View {
    //Colors
    private let profileBackgroundColor: Color = .gray
    private let signOutIconColor: Color = Color(uiColor: .lightGray)
    //Storage test를 위한 선언으로 삭제 예정
    //PhotoPickerItem을 설정한다.
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedItemName: String? = nil
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
                            firestoreManager.addLetter(writer: "me", recipient: "you", summary: "ImageTest", date: Date(), imageName: selectedItemName!)
                            firestoreManager.fetchAllLetters()
                        } label: {
                            Text("Add")
                        } //firestore 데이터 추가 테스트를 위한 버튼으로 삭제 예정
                        
                        //matching: 어떤 타입의 데이터와 매치하는가
                        //photoLibrary: .shared() 보편적인 사진 앨범
                        PhotosPicker(selection: $selectedItem,
                                     matching: .images,
                                     photoLibrary: .shared()) {
                            Text("Select a photo")
                        } //Storage업로드 테스트를 위한 구현으로 삭제 예정
                    } //Section: Home뷰에서 기능 되는 것 확인 후 삭제 예정
                    .onChange(of: selectedItem) { newValue in
                        if let newValue {
                            saveImage(item: newValue)
                        }
                    }
                    
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

#Preview {
    SettingView()
}
