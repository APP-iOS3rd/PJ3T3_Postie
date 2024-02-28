//
//  FirestoreNoticeManager.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 2/15/24.
//

import OSLog

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
                Logger.firebase.info("\(error)")
                return
            }
            
            self.notices.removeAll()
            
            guard let snapshot = snapshot else {
                Logger.firebase.info("\(#function): No snapshot \(String(describing: error?.localizedDescription))")
                return
            }
            
            for document in snapshot.documents {
                do {
                    let data = try document.data(as: OfficialLetter.self)
                    
                    self.notices.append(data)
                } catch {
                    Logger.firebase.info("\(#function) \(error.localizedDescription)")
                }
            }
            
            Logger.firebase.info("Notice fetch success")
        }
    }
}
