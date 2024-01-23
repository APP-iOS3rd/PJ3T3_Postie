//
//  FirestoreViewModel.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 1/17/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

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
    
    private init() { }

    //새로운 편지를 추가한다.
    func addLetter(writer: String, recipient: String, summary: String, date: Date, imageName: String) {
        let document = colRef.document(userUid).collection("letters").document() //새로운 document를 생성한다.
        let documentId = document.documentID //생성한 document의 id를 가져온다.
        //Letter model에 맞는 모양으로 document data를 생성한다.
        let docData: [String: Any] = [
            "id": documentId,
            "writer": writer,
            "recipient": recipient,
            "summary": summary,
            "date": date,
            "imageName": imageName
        ]

        //생성한 데이터를 해당되는 경로에 새롭게 생성한다. 이때 overwrite 하지 않는다.
        document.setData(docData, merge: false) { error in
            if let error = error {
                print(error)
            } else {
                print("Success:", documentId)
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
                                           imageName: data["imagePath"] as? String))
            }
        }
    }
}
