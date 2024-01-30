//
//  FirestoreViewModel.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 1/17/24.
//

import FirebaseFirestore

class FirestoreManager: ObservableObject {
    static let shared = FirestoreManager()
    var letterColRef: CollectionReference
    var docId: String = ""
    @Published var letters: [Letter] = []
    @Published var shops: [Shop] = []
    
    private init() { 
        let userUid = AuthManager.shared.userUid
        self.letterColRef = Firestore.firestore().collection("users").document(userUid).collection("letters")
        fetchAllLetters()
        fetchAllShops()
    }

    //새로운 편지를 추가한다.
    func addLetter(writer: String, recipient: String, summary: String, date: Date, text: String, isReceived: Bool, isFavorite: Bool) async {
        let document = letterColRef.document() //새로운 document를 생성한다.
        let documentId = document.documentID //생성한 document의 id를 가져온다.
        self.docId = documentId
        print(self.docId)
        
        //Letter model에 맞는 모양으로 document data를 생성한다.
        let docData: [String: Any] = [
            "id": documentId,
            "writer": writer,
            "recipient": recipient,
            "summary": summary,
            "date": date,
            "text": text,
            "isReceived": isReceived,
            "isFavorite": isFavorite
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
    func editLetter(documentId: String, writer: String, recipient: String, summary: String, date: Date, text: String, isReceived: Bool, isFavorite: Bool) {
        let docRef = letterColRef.document(documentId)
        let docData: [String: Any] = [
            "id": documentId,
            "writer": writer,
            "recipient": recipient,
            "summary": summary,
            "date": date,
            "text": text,
            "isReceived": isReceived,
            "isFavorite": isFavorite
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
    func deleteLetter(documentId: String) {
        let docRef = letterColRef.document(documentId)
        
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
        //letterColRef(특정 user의 document의 letters라는 하위 컬렉션)에 있는 모든 document를 가져옴
        letterColRef.getDocuments { snapshot, error in
            guard error == nil else {
                print(error?.localizedDescription ?? "Undefined error")
                return
            }
            
            //우선 전체 내용을 지우고 전체를 추가한다.
            self.letters.removeAll()
            
            guard let snapshot = snapshot else {
                print("\(#function): No snapshot \(String(describing: error?.localizedDescription))")
                return
            }
            
            for document in snapshot.documents {
                let data = document.data()
                
                //document의 data를 가지고 와서, data를 각 값에 넣어줌
                self.letters.append(Letter(id: data["id"] as? String ?? "",
                                           writer: data["writer"] as? String ?? "",
                                           recipient: data["recipient"] as? String ?? "",
                                           summary: data["summary"] as? String ?? "",
                                           date: data["date"] as? Date ?? Date(),
                                           text: data["text"] as? String ?? "",
                                           isReceived: data["isReceived"] as? Bool ?? true,
                                           isFavorite: data["isFavorite"] as? Bool ?? false))
                
                //위의 코드는 값을 manual하게 mapping해 주어야 하므로 구조체에 업데이트가 발생하거나 오타가 발생하면 작동하지 않는다는 단점이 있습니다.
                //아래와 같이 코드 개선이 가능하지만 현재 Letter 구조체의 변수 images의 key가 mapping되지 않아 fetch가 되지 않습니다.
                //우선 주석으로 작성 해 두고 추후 위의 코드와 교체 할 예정입니다.
//                do {
//                    let letter = try document.data(as: Letter.self)
//                    self.letters.append(letter)
//                    print("Fetch letter success")
//                } catch let DecodingError.dataCorrupted(context) {
//                    print(context)
//                } catch let DecodingError.keyNotFound(key, context) {
//                    print("Key '\(key)' not found:", context.debugDescription)
//                    print("codingPath:", context.codingPath)
//                } catch let DecodingError.valueNotFound(value, context) {
//                    print("Value '\(value)' not found:", context.debugDescription)
//                    print("codingPath:", context.codingPath)
//                } catch let DecodingError.typeMismatch(type, context)  {
//                    print("Type '\(type)' mismatch:", context.debugDescription)
//                    print("codingPath:", context.codingPath)
//                } catch {
//                    print("error: ", error)
//                }
            }
            
            print("Letter fetch success")
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
                print("\(#function): No snapshot \(String(describing: error?.localizedDescription))")
                return
            }
            
            for document in snapshot.documents {
                do {
                    let data = try document.data(as: Shop.self)
                    
                    self.shops.append(data)
                } catch {
                    print(#function, error.localizedDescription)
                }
            }
            
            print("Shop fetch success")
        }
    }
}
