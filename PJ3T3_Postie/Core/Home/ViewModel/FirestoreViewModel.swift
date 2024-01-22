//
//  FirestoreViewModel.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 1/17/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class FirestoreViewModel: ObservableObject {
    static let shared = FirestoreViewModel()
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
    func addLetter(writer: String, recipient: String, summary: String, date: Date) {
        let document = colRef.document(userUid).collection("letters").document() //새로운 document를 생성한다.
        let documentId = document.documentID //생성한 document의 id를 가져온다.

        //Letter model에 맞는 모양으로 document data를 생성한다.
        let docData: [String: Any] = [
            "id": documentId,
            "writer": writer,
            "recipient": recipient,
            "summary": summary,
            "date": date,
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
}
