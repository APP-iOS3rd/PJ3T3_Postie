//
//  FirestoreNoticeManager.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 2/15/24.
//

import FirebaseFirestore

final class FirestoreNoticeManager: ObservableObject {
    static let shared = FirestoreNoticeManager()
    @Published var notices: [OfficialLetter] = []
    @Published var faqs: [OfficialLetter] = []
    
    private init() { }
    
    func fetchAllNotices() {
        let docRef = Firestore.firestore().collection("notice")
        
        docRef.getDocuments { snapshot, error in
            guard error == nil else {
                print(error?.localizedDescription ?? "Undefined error")
                return
            }
            
            self.notices.removeAll()
            
            guard let snapshot = snapshot else {
                print("\(#function): No snapshot \(String(describing: error?.localizedDescription))")
                return
            }
            
            for document in snapshot.documents {
                do {
                    let data = try document.data(as: OfficialLetter.self)
                    
                    self.notices.append(data)
                } catch {
                    print(#function, error.localizedDescription)
                }
            }
            
            print("Notice fetch success")
        }
    }
}
