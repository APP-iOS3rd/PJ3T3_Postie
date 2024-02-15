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
                        .confirmationDialog("포스티를 떠나시나요?", isPresented: $isDeleteAccountDialogPresented, titleVisibility: .visible) {
                            Button("계정 삭제", role: .destructive) {
                                switch authManager.provider {
                                case .email:
                                    Task {
                                        print("Delete Email account")
                                        //회원 탈퇴를 위해 재로그인하는 과정이 필요합니다.
                                        //기능 구현여부 테스트를 위해 하드코딩 하였다가 주석처리 했습니다.
//                                        await authManager.deleteEmailUser(email: "eunice@test.com", password: "123456")
//                                        showLoading = true
                                    }
                                case .google:
                                    print("Delete Google account")
                                    Task {
                                        do {
                                            try await authManager.deleteGoogleAccount()
                                            showLoading = true
                                        } catch {
                                            print(#function, "Failed to delete Google account: \(error)")
                                            showLoading = false
                                        }
                                    }
                                case .apple:
                                    print("Delete Apple account")
                                    appleSignInHelper.deleteCurrentAppleUser()
                                default:
                                    print("Delete account")
                                    //alert 창 구현
                                }
                            }
                            .onChange(of: authManager.credential) { newValue in
                                if authManager.credential == nil {
                                    print(#function, "Canceled to delete account")
                                    showLoading = false
                                } else {
                                    showLoading = true
                                }
                            }
                        } message: {
                            Text("회원 탈퇴 시에는 계정과 프로필 정보, 그리고 등록된 모든 편지와 편지 이미지가 삭제되며 복구할 수 없습니다. 계정 삭제를 위해서는 재인증을 통해 다시 로그인 해야 합니다.")
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
        .fullScreenCover(isPresented: $showLoading) {
            LoadingView(text: "저장된 편지들을 안전하게 삭제하는 중이에요", isThemeGroupButton: .constant(0))
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
                uploadLetter(uiImages: selectedImages)
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
                print(selectedImages)
            } else {
                //alert 구현 필요
                print("\(#function): 이미지를 array에 추가하는데 실패했습니다.")
                return
            }
        }
    }
    
    //userUid를 AuthManager에서 가져오도록 리팩토링 필요
    func uploadLetter(uiImages: [UIImage]) {
        Task {
            //letter객체를 만들어 append한다면 id는 어떻게 하지?
            //firestore에 document를 저장한다.
            await firestoreManager.addLetter(writer: "me",
                                             recipient: "you",
                                             summary: "refacrorTest",
                                             date: Date(),
                                             text: "?.?",
                                             isReceived: false,
                                             isFavorite: false)
            firestoreManager.fetchAllLetters() //변경사항을 fetch한다.
            //함수가 호출되면 uiImages가 빈 배열이 아닌지 확인해 빈 배열이 아닐 경우 storage에 이미지를 업로드 하고
            //이미지 업로드가 성공하면 urlString들이 저장된 배열을 return받아 selectedImageUrls에 저장한다.
            if !uiImages.isEmpty {
                try await storageManager.saveUIImage(images: uiImages, docId: firestoreManager.docId)
            }
            
            firestoreManager.docId = ""
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
            writer = letter.writer
            recipient = letter.recipient
            summary = letter.summary
            text = letter.text
            storageManager.listAllFile(docId: letter.id)
        }
        .onDisappear {
            //뷰가 dismiss될 때 images 배열 초기화
            storageManager.images.removeAll()
        }
    }
}

struct TestImageView: View {
    @ObservedObject var storageManager = StorageManager.shared
    let rows = Array(repeating: GridItem(.adaptive(minimum: 100)), count: 1)
    var images: [LetterPhoto]
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: rows) {
                ForEach(images, id: \.self) { img in
                    //LetterPhoto의 UIImage 타입으로 저장된 변수를 사용할 수도 있다: Image(uiImage: img.image)
                    AsyncImage(url: URL(string: img.urlString)) { image in
                        ZStack(alignment: .topTrailing) {
                            image
                                .resizable()
                                .frame(width: 150, height: 150)
                                .scaledToFit()
                                .padding(.leading, 10)
                            
                            Button {
                                storageManager.deleteItem(fullPath: img.fullPath)
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(.gray)
                                    .frame(width: 20, height: 20)
                                    .padding(5)
                            }
                        }
                    } placeholder: {
                        ProgressView()
                    }
                }
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
                ForEach(firestoreNoticeManager.notice, id:\.self) { notice in
                    Text(notice.title)
                }
            }
        }
        .onAppear {
            firestoreNoticeManager.fetchAllNotices()
        }
    }
}

#Preview {
    SettingView()
}
