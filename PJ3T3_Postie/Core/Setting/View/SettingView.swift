//
//  SettingView.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 1/17/24.
//

import SwiftUI
import PhotosUI //Storage test를 위한 import로 이후 삭제 예정

struct SettingView: View {
    @Environment(\.window) var window: UIWindow?
    @ObservedObject var authManager = AuthManager.shared
    @ObservedObject var appleSignInHelper = AppleSignInHelper.shared
    //Colors
    private let profileBackgroundColor: Color = .gray
    private let signOutIconColor: Color = Color(uiColor: .lightGray)
    @State private var isDeleteAccountDialogPresented = false
    @State private var showLoading = false
    
    var body: some View {
        NavigationStack {
            if let user = authManager.currentUser {
                List {
                    Section {
                        HStack {
                            if let profileImageUrl = user.profileImageUrl {
                                AsyncImage(url: URL(string: profileImageUrl), content: { image in
                                    image
                                        .resizable()
                                        .frame(width: 72, height: 72)
                                }, placeholder: {
                                    ZStack {
                                        Circle()
                                            .foregroundStyle(.postieGray)
                                            .frame(width: 72, height: 72)
                                        
                                        ProgressView()
                                    }
                                })
                            } else {
                                Circle()
                                    .foregroundStyle(.postieGray)
                                    .frame(width: 72, height: 72)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(user.fullName)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .padding(.top, 4)
                                
                                Text(user.email)
                                    .font(.footnote)
                                    .foregroundStyle(profileBackgroundColor)
                            }
                        }
                    }
                    
                    Section("General") {
                        HStack {
                            SettingsRowView(imageName: "gear", title: "Version", tintColor: profileBackgroundColor)
                            
                            Spacer()
                            
                            Text("1.0.0")
                                .font(.subheadline)
                                .foregroundStyle(profileBackgroundColor)
                        }
                    }
                    
                    Section("Account") {
                        Button {
                            authManager.signOut()
                        } label: {
                            SettingsRowView(imageName: "arrow.left.circle.fill", title: "Sign Out", tintColor: signOutIconColor)
                        }
                        
                        Button {
                            isDeleteAccountDialogPresented = true
                        } label: {
                            SettingsRowView(imageName: "xmark.circle.fill", title: "Delete Account", tintColor: signOutIconColor)
                        }
                    }
                    
                    NoticeTestView()
                    
                    AddDataSectionView()
                    
                    LetterDataListView()
                    
                    ShopListView()
                }
                .navigationTitle("Setting")
            } else {
                ProgressView() //로그인 중
            }
        }
        .onAppear {
            appleSignInHelper.window = window
        }
        .confirmationDialog("포스티를 떠나시나요?", isPresented: $isDeleteAccountDialogPresented, titleVisibility: .visible) {
            DeleteAccountButtonView(showLoading: $showLoading)
        } message: {
            Text("회원 탈퇴 시에는 계정과 프로필 정보, 그리고 등록된 모든 편지와 편지 이미지가 삭제되며 복구할 수 없습니다. 계정 삭제를 위해서는 재인증을 통해 다시 로그인 해야 합니다.")
        }
        .fullScreenCover(isPresented: $showLoading) {
            LoadingView(text: "저장된 편지들을 안전하게 삭제하는 중이에요")
                .background(ClearBackground())
        }
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
                newUploadLetter(uiImages: selectedImages)
                selectedImages = [] //uploadLetter 작업을 수행 한 이후 잘못된 이미지가 업로드 되는 일이 없도록 배열을 초기화 해 준다.
            } label: {
                Text("Save Letter")
            }
        }
        .onChange(of: selectedItem) { newValue in
            if let newValue {
                appendImages(item: newValue)
            }
            selectedItem = nil
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
                let imgData = NSData(data: uiImage.jpegData(compressionQuality: 1)!)
                var imageSize: Int = imgData.count
                print("actual size of image in KB: %f ", Double(imageSize) / 1000.0)
                print(selectedImages)
            } else {
                //alert 구현 필요
                print("\(#function): 이미지를 array에 추가하는데 실패했습니다.")
                return
            }
        }
    }
    
    func newUploadLetter(uiImages: [UIImage]) {
        let docId = UUID().uuidString
        var newImageFullPaths = [String]()
        var newImageURLs = [String]()
        
        Task {
            for img in uiImages {
                do {
                    let fullPath = try await storageManager.uploadUIImage(image: img, docId: docId)
                    let url = try await storageManager.requestImageURL(fullPath: fullPath)
                    
                    newImageFullPaths.append(fullPath)
                    newImageURLs.append(url)
                } catch {
                    print(#function, "Failed to upload image with: \(error)")
                }
            }
            do {
                let newLetter = Letter(id: docId,
                                       writer: "포스티",
                                       recipient: "포스티팀",
                                       summary: "이미지 있음, 새 로직",
                                       date: Date(),
                                       text: "새 로직으로 업로드 성공!",
                                       isReceived: true,
                                       isFavorite: true,
                                       imageURLs: newImageURLs,
                                       imageFullPaths: newImageFullPaths)
                
                try await firestoreManager.addLetter(docId: docId, letter: newLetter)
                firestoreManager.letters.append(newLetter) //fetch 생략 가능
            } catch {
                print(#function, "Failed to upload document with: \(error)")
            }
        }
    }
}

//Firestore에 저장된 데이터를 리스트로 보여주는 뷰: 기능 테스트 후 삭제 예정
struct LetterDataListView: View {
    @ObservedObject var firestoreManager = FirestoreManager.shared
    
    var body: some View {
        ForEach(firestoreManager.letters, id: \.self) { letter in
            NavigationLink {
                TestDetailView(letter: letter)
            } label: {
                VStack {
                    HStack {
                        Text("To: \(letter.recipient)")
                        
                        Spacer()
                    }
                    
                    Text("\(letter.summary)")
                    
                    HStack {
                        Spacer()
                        
                        Text("From: \(letter.writer)")
                    }
                }
            }
        }
    }
}

struct TestDetailView: View {
    @ObservedObject var firestoreManager = FirestoreManager.shared
    @ObservedObject var storageManager = StorageManager.shared
    @Environment(\.dismiss) var dismiss
    var letter: Letter
    @State var writer = ""
    @State var recipient = ""
    @State var summary = ""
    @State var text = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("보낸 사람")
                
                TextField("\(letter.writer)", text: $writer)
                    .textFieldStyle(.roundedBorder)
                
                Text("받는 사람")
                
                TextField("\(letter.recipient)", text: $recipient)
                    .textFieldStyle(.roundedBorder)
                
                Text("한 줄 요약")
                
                TextField("\(letter.summary)", text: $summary)
                    .textFieldStyle(.roundedBorder)
                
                Text("내용")
                
                TextField("\(letter.text)", text: $text)
                    .textFieldStyle(.roundedBorder)
                
                if !storageManager.images.isEmpty {
                    TestImageView(images: storageManager.images)
                }
            }
            
            HStack {
                PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                    Text("사진 추가")
                }
                .buttonStyle(.borderedProminent)
                
                Button {
                    firestoreManager.editLetter(documentId: letter.id,
                                                writer: writer,
                                                recipient: recipient,
                                                summary: summary,
                                                date: Date(),
                                                text: text,
                                                isReceived: false,
                                                isFavorite: false)
                    firestoreManager.fetchAllLetters()
                    dismiss()
                } label: {
                    Text("수정 완료")
                }
                .buttonStyle(.borderedProminent)
                
                Button {
                    firestoreManager.deleteLetter(documentId: letter.id)
                    firestoreManager.fetchAllLetters()
                    dismiss()
                } label: {
                    Text("삭제")
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .onAppear {
            initLetterDetail()
        }
        .onChange(of: selectedItem) { newValue in
            if let newValue {
                appendImages(item: newValue)
            }
            selectedItem = nil
        }
    }
    
    func initLetterDetail() {
        writer = letter.writer
        recipient = letter.recipient
        summary = letter.summary
        text = letter.text
        
        if let currentFullPaths = letter.imageFullPaths {
            self.currentFullPaths = currentFullPaths
        }
        
        if let currentUrls = letter.imageURLs {
            self.currentUrls = currentUrls
        }
        
        if currentUrls.count == currentFullPaths.count {
            let imageCount = currentUrls.count
            
            for i in 0..<imageCount {
                currentFullPathAndURLs.append([currentFullPaths[i], currentUrls[i]])
            }
        } else {
            print("현재 letter는 Image url의 개수와 fullPath의 개수가 다릅니다.")
        }
    }
    
    func appendImages(item: PhotosPickerItem) {
        Task {
            //지정한 타입의 인스턴스를 불러오려고 시도한다. 실패 action 구현 필요
            guard let image = try await item.loadTransferable(type: Data.self) else { return }
            
            if let uiImage = UIImage(data: image) {
                selectedImages.append(uiImage)
                let imgData = NSData(data: uiImage.jpegData(compressionQuality: 1)!)
                let imageSize: Int = imgData.count
                print("actual size of image in KB: %f ", Double(imageSize) / 1000.0)
                print(selectedImages)
            } else {
                //alert 구현 필요
                print("\(#function): 이미지를 array에 추가하는데 실패했습니다.")
                return
            }
        }
    }
}

struct ShopListView: View {
    @ObservedObject var firestoreShopManager = FirestoreShopManager.shared
    
    var body: some View {
        ForEach(firestoreShopManager.shops, id: \.self) { shop in
            HStack {
                Text(shop.title)
                
                AsyncImage(url: URL(string: shop.thumbUrl)) { image in
                    image
                        .resizable()
                        .frame(width: 100, height: 100)
                } placeholder: {
                    ProgressView()
                }
            }
        }
    }
}

struct NoticeTestView: View {
    @ObservedObject var firestoreNoticeManager = FirestoreNoticeManager.shared
    
    var body: some View {
        VStack {            
            Section {
                ForEach(firestoreNoticeManager.notices, id:\.self) { notice in
                    Text(notice.title)
                }
            }
        }
        .onAppear {
            if firestoreNoticeManager.notices.isEmpty {
                firestoreNoticeManager.fetchAllNotices()
            }
        }
    }
}

#Preview {
    SettingView()
}
