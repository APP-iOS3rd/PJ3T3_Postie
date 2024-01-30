//
//  FirestoreViewModel.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 1/17/24.
//

import FirebaseAuth
import FirebaseFirestore

@MainActor
class FirestoreManager: ObservableObject {
    static let shared = FirestoreManager()
    var colRef = Firestore.firestore().collection("users") //user 컬렉션 전체를 가져온다.
    var userUid: String {
        //로그인된 유저가 있는지 확인해서 firebase에서 제공하는 userUid를 가지고온다.
        if let uid = Auth.auth().currentUser?.uid {
            return uid
        }

        return ""
    }
    @Published var letters: [Letter] = []
    @Published var shops: [Shop] = []
    @Published var docId: String = ""
    
    private init() { 
        fetchAllLetters()
        fetchAllShops()
    }

    //새로운 편지를 추가한다.
    func addLetter(writer: String, recipient: String, summary: String, date: Date, text: String) async {
        let document = colRef.document(userUid).collection("letters").document() //새로운 document를 생성한다.
        let documentId = document.documentID //생성한 document의 id를 가져온다.
        
        docId = documentId
        print(docId)
        //Letter model에 맞는 모양으로 document data를 생성한다.
        let docData: [String: Any] = [
            "id": documentId,
            "writer": writer,
            "recipient": recipient,
            "summary": summary,
            "date": date,
            "text": text
        ]

        //생성한 데이터를 해당되는 경로에 새롭게 생성한다. merge false: overwrite a document or create it if it doesn't exist yet
        do {
            try await document.setData(docData, merge: false)
            print("Success:", documentId)
        } catch {
            print("\(#function): \(error.localizedDescription)")
        }
    }
    
    /// 데이터의 위치와 수정 후 데이터를 받아 firestore에 업데이트 한다.
    /// - Parameters:
    ///   - documentId: letter 구조체 안에 저장된 id를 가져옴
    ///   - writer: 변경 된 보낸 사람
    ///   - recipient: 변경 된 받는 사람
    ///   - summary: 변경 된 한 줄 요약
    ///   - date: 편지를 보내거나 받은 날짜
    ///   - text: 변경 된 편지 본문
    func editLetter(documentId: String, writer: String, recipient: String, summary: String, date: Date, text: String) {
        let docRef = colRef.document(userUid).collection("letters").document(documentId)
        let docData: [String: Any] = [
            "id": documentId,
            "writer": writer,
            "recipient": recipient,
            "summary": summary,
            "date": date,
            "text": text
        ]
        
        docRef.updateData(docData) { error in
            if let error = error {
                print("Error writing document: ", error)
            } else {
                print("\(documentId) merge success")
                print(docData)
            }
        }
    }
    
    //데이터 삭제
    //Storage의 이미지도 같이 삭제하도록 설정해야 한다.
    func deleteRestaurant(documentId: String) {
        let docRef = colRef.document(userUid).collection("letters").document(documentId)
        
        docRef.delete() { error in
            if let error = error {
                print("Error writing document: ", error)
            } else {
                print("\(documentId) delete success")
            }
        }
    }
    
    //데이터 전체를 가지고 온다.
    func fetchAllLetters() {
        let docRef = colRef.document(userUid).collection("letters") //특정 user의 document의 letters라는 하위 컬렉션 가져옴
        
        docRef.getDocuments { snapshot, error in
            guard error == nil else {
                print(error?.localizedDescription ?? "Undefined error")
                return
            }
            
            //우선 전체 내용을 지우고 전체를 추가한다.
            self.letters.removeAll()
            
            guard let snapshot = snapshot else {
                print("\(#function): \(error?.localizedDescription)")
                return
            }
            
            for document in snapshot.documents {
                let data = document.data()
                
                print("Fetch success")
                
                //document의 data를 가지고 와서, data를 각 값에 넣어줌
                self.letters.append(Letter(id: data["id"] as? String ?? "",
                                           writer: data["writer"] as? String ?? "",
                                           recipient: data["recipient"] as? String ?? "",
                                           summary: data["summary"] as? String ?? "",
                                           date: data["date"] as? Date ?? Date(),
                                           text: data["text"] as? String ?? ""))
            }
        }
    }
    
    func fetchAllShops() {
        let docRef = Firestore.firestore().collection("shops")
        
        docRef.getDocuments { snapshot, error in
            guard error == nil else {
                print(error?.localizedDescription ?? "Undefined error")
                return
            }
            
            self.shops.removeAll()
            
            guard let snapshot = snapshot else {
                print("\(#function): \(error?.localizedDescription)")
                return
            }
            
            for document in snapshot.documents {
                let data = document.data()
                
                print("Shop Fetch success")
                
                //document의 data를 가지고 와서, data를 각 값에 넣어줌
                self.shops.append(Shop(id: data["id"] as? String ?? "",
                                       shopUrl: data["shopUrl"] as? String ?? "",
                                       thumbUrl: data["thumbUrl"] as? String ?? "",
                                       title: data["title"] as? String ?? "",
                                       category: data["category"] as? String ?? ""))
            }
        }
    }
}
