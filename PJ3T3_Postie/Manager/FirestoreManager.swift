//
//  FirestoreViewModel.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 1/17/24.
//

import FirebaseFirestore

class FirestoreManager: ObservableObject {
    static let shared = FirestoreManager()
    var letterColRef: CollectionReference = Firestore.firestore().collection("users")
    @available(*, deprecated, message: "모든 뷰에서 제거 해주세요. 제거가 완료되면 이 변수를 삭제 후 커밋 해 주세요.")
    var docId: String = "" //deprecated
    @Published var letters: [Letter] = []

//    @available(*, deprecated, message: "모든 뷰에서 제거 해주세요. 제거가 완료되면 이 변수를 삭제 후 커밋 해 주세요.")
    @Published var letter: Letter = Letter(id: "", writer: "", recipient: "", summary: "", date: Date(), text: "", isReceived: false, isFavorite: false) //deprecated

    private init() { 
        fetchReference()
    }
    
    func fetchReference() {
        let userUid = AuthManager.shared.userUid
        self.letterColRef = Firestore.firestore().collection("users").document(userUid).collection("letters")
        fetchAllLetters()
    }

//MARK: - 편지 추가
    func addLetter(docId: String, letter: Letter) async throws {
        try letterColRef.document(docId).setData(from: letter)
    }
    
    ///이 함수를 사용할 경우 업로드 완료시 fetchAllLetters를 수행 해 주세요.
    func addLetter(docId: String, writer: String, recipient: String, summary: String, date: Date, text: String, isReceived: Bool, isFavorite: Bool, imageURLs: [String]?, imageFullPaths: [String]?) async throws {
        //imageURLs와 imageFullPaths 둘 중 하나만 nil인 경우를 걸러낼 수 있을까요?
        let letter = Letter(id: docId,
                            writer: writer,
                            recipient: recipient,
                            summary: summary,
                            date: date,
                            text: text,
                            isReceived: isReceived,
                            isFavorite: isFavorite,
                            imageURLs: imageURLs,
                            imageFullPaths: imageFullPaths)
        
        try letterColRef.document(docId).setData(from: letter)
    }
    
    @available(*, deprecated, message: "모든 뷰에서 제거 해주세요. 제거가 완료되면 이 함수의 코드도 삭제 후 커밋 해 주세요.")
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
    
//MARK: - 편지 수정
    /// 데이터의 위치와 수정 후 데이터를 받아 firestore에 업데이트 한다.
    /// - Parameters:
    ///   - documentId: letter 구조체 안에 저장된 id를 가져옴
    ///   - writer: 변경 된 보낸 사람
    ///   - recipient: 변경 된 받는 사람
    ///   - summary: 변경 된 한 줄 요약
    ///   - date: 편지를 보내거나 받은 날짜
    ///   - text: 변경 된 편지 본문
    @available(*, deprecated, message: "이 함수는 더이상 사용하지 않습니다. updateLetter 함수를 사용 해 주세요. 뷰에서 더이상 사용하는 곳이 없다면 함수를 삭제 해 주세요.")
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
    
    func updateLetter(docId: String, writer: String, recipient: String, summary: String, date: Date, text: String, isReceived: Bool, isFavorite: Bool, imageURLs: [String]?, imageFullPaths: [String]?) {
        let docRef = letterColRef.document(docId)
        var docData = [String: Any]()
        
        if let imageURLs = imageURLs, let imageFullPaths = imageFullPaths {
            docData = ["id": docId,
                       "writer": writer,
                       "recipient": recipient,
                       "summary": summary,
                       "date": date,
                       "text": text,
                       "isReceived": isReceived,
                       "isFavorite": isFavorite,
                       "imageURLs": FieldValue.arrayUnion(imageURLs),
                       "imageFullPaths": FieldValue.arrayUnion(imageFullPaths)]
        } else {
            docData = ["id": docId,
                       "writer": writer,
                       "recipient": recipient,
                       "summary": summary,
                       "date": date,
                       "text": text,
                       "isReceived": isReceived,
                       "isFavorite": isFavorite]
        }
        
        docRef.updateData(docData) { error in
            if let error = error {
                print("Failed to updating document: ", error)
            } else {
                print("\(docId) merge success")
            }
        }
    }

    func updateLetterAsync(docId: String, writer: String, recipient: String, summary: String, date: Date, text: String, isReceived: Bool, isFavorite: Bool, imageURLs: [String]?, imageFullPaths: [String]?) async throws {
        let docRef = letterColRef.document(docId)
        var docData = [String: Any]()

        if let imageURLs = imageURLs, let imageFullPaths = imageFullPaths {
            docData = ["id": docId,
                       "writer": writer,
                       "recipient": recipient,
                       "summary": summary,
                       "date": date,
                       "text": text,
                       "isReceived": isReceived,
                       "isFavorite": isFavorite,
                       "imageURLs": FieldValue.arrayUnion(imageURLs),
                       "imageFullPaths": FieldValue.arrayUnion(imageFullPaths)]
        } else {
            docData = ["id": docId,
                       "writer": writer,
                       "recipient": recipient,
                       "summary": summary,
                       "date": date,
                       "text": text,
                       "isReceived": isReceived,
                       "isFavorite": isFavorite]
        }

        try await docRef.updateData(docData)
    }

    func removeFullPathsAndURLs(docId: String, fullPaths: [String], urls: [String]) {
        let docRef = letterColRef.document(docId)

        docRef.updateData(["imageURLs": FieldValue.arrayRemove(urls),
                           "imageFullPaths": FieldValue.arrayRemove(fullPaths)]) { error in
            if let error = error {
                print(#function, "Failed to update fullPath and url: ", error)
            } else {
                print("\(docId) merge success")
            }
        }
    }

    func removeFullPathsAndUrlsAsync(docId: String, fullPaths: [String], urls:  [String]) async throws {
        let docRef = letterColRef.document(docId)

        try await docRef.updateData(["imageURLs": FieldValue.arrayRemove(urls),
                           "imageFullPaths": FieldValue.arrayRemove(fullPaths)])
    }

    func getLetter(docId: String) async throws -> Letter {
        let docRef = letterColRef.document(docId)

        return try await docRef.getDocument(as: Letter.self)
    }

    func updateIsFavorite(docId: String, isFavorite: Bool) async throws {
        let docRef = letterColRef.document(docId)

        try await docRef.updateData([
            "isFavorite" : isFavorite
        ])
    }

//MARK: - 편지 fetch
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
                
                do {
                    let letter = try document.data(as: Letter.self)
                    self.letters.append(letter)
                } catch let DecodingError.dataCorrupted(context) {
                    print(context)
                } catch let DecodingError.keyNotFound(key, context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.valueNotFound(value, context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.typeMismatch(type, context)  {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch {
                    print("Undefined error: ", error)
                }
            }
            
            print("Letter fetch success")
        }
    }

    func fetchAllLettersAsync() async throws {
        let snapshot = try await letterColRef.getDocuments()
        await MainActor.run {
            self.letters.removeAll()
        }

        for document in snapshot.documents {
            let letter = try document.data(as: Letter.self)
            await MainActor.run {
                self.letters.append(letter)
            }
        }
    }

//MARK: - 편지 삭제
    func deleteLetter(documentId: String) {
        let docRef = letterColRef.document(documentId)
        
        docRef.delete() { error in
            if let error = error {
                print(#function, "Error deleting document: ", error)
            } else {
                print(#function, "\(documentId) delete success")
            }
        }
    }

    func deleteLetterAsync(documentId: String) async throws {
        let docRef = letterColRef.document(documentId)
        
        try await docRef.delete()
    }

    func deleteUserDocument(userUid: String) {
        let userDocRef = Firestore.firestore().collection("users").document(userUid)
        var letterQty = 0
        
        for letter in letters {
            self.deleteLetter(documentId: letter.id)
            StorageManager.shared.deleteFolder(docId: letter.id)
            letterQty += 1
        }
        
        print("Deleted \(letterQty)letters")
        
        userDocRef.delete { error in
            if let error = error {
                print(#function, "Error deleting document: ", error)
            } else {
                print(#function, "\(userUid) delete success")
            }
        }
    }
}
