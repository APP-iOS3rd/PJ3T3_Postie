//
//  AuthViewModel.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 1/17/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User? //Firebase user object
    @Published var currentUser: User? //User Data Model
    static let shared = AuthViewModel()
    
    private init() {
        //viewModel이 init될 때 이미 존재하는 user가 있는지 확인한다.
        //이 기능은 Firebase에서 제공하는 기능으로 currentUser가 로그인을 했는지(한 상태인지)에 대한 정보를 디바이스에 캐시 데이터로 저장해 둔다.
        self.userSession = Auth.auth().currentUser
    }

    func signIn(withEamil email: String, password: String) async throws {
        print(#function)
    }

    func createUser(withEamil email: String, password: String, fullName: String) async throws {
        do {
            //1. Try to create user -> await its result -> store it to the property
            let result = try await Auth.auth().createUser(withEmail: email, password: password)

            //2. Once success, set userSession property
            self.userSession = result.user //result에서 user값을 받아와 userSession에 넣어줌

            //3. Create our User object
            //firebase의 user는 firebase에서 새로운 user를 생성하고 uid 를 제공해준다.
            //기타 사용자에게 얻고자 하는 데이터(예: 핸드폰 번호, 생일 등)가 있다면 User Model에 구성을 추가하고 input을 받아야 한다.
            let user = User(id: result.user.uid, fullName: fullName, email: email)

            //4. Encode the object throught the codable protocol
            let encodedUser = try Firestore.Encoder().encode(user)

            //5. Upload data to Firestore
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
        } catch {
            //if anything goes wrong:
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
        }
    }

    func signOut() {

    }

    func deleteAccount() {

    }

    func fetchUser() async {

    }
}
