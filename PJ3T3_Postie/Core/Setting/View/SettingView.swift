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
}

//이미지를 선택해 Storage와 Firestore에 데이터를 추가하는 뷰: 기능 테스트 후 삭제 예정
struct AddDataSectionView: View {
    @ObservedObject var firestoreManager = FirestoreManager.shared
    @ObservedObject var storageManager = StorageManager.shared
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImages: [UIImage] = []
    
    var body: some View {
        Section("Data Test") {
            //matching: 어떤 타입의 데이터와 매치하는가, photoLibrary: .shared() 보편적인 사진 앨범
            PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                Text("Select a photo")
            }
            
            //photoPicker에서 이미지를 선택할 때 마다 onchange로 감지하여 selectedImages에 UIImage가 append 된다.
            Button {
                selectedImages = [] //uploadLetter 작업을 수행 한 이후 잘못된 이미지가 업로드 되는 일이 없도록 배열을 초기화 해 준다.
            } label: {
                Text("Add Letter")
            }
        }
        .onChange(of: selectedItem) { newValue in
            if let newValue {
                appendImages(item: newValue)
            }
            selectedItem = nil
        }
        .onAppear {
            firestoreManager.fetchAllLetters()
        }
    }
    
    /// SwiftUI의 PhotosUI를 사용해 이미지를 선택하고 UIImageArray에 추가한다.
    /// - Parameter item: PhotosUI로 선택된 이미지
    func appendImages(item: PhotosPickerItem) {
        Task {
            //지정한 타입의 인스턴스를 불러오려고 시도한다. 실패 action 구현 필요
            guard let image = try await item.loadTransferable(type: Data.self) else { return }
            if let uiImage = UIImage(data: image) {
                selectedImages.append(uiImage)
                print(selectedImages)
            } else {
                //alert 구현 필요
                print("\(#function): 이미지를 array에 추가하는데 실패했습니다.")
                return
            }
        }
    }
}

#Preview {
    SettingView()
}
