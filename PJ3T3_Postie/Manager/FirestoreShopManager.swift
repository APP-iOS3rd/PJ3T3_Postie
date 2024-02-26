//
//  FirestoreShopManager.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 2/15/24.
//

import OSLog

import FirebaseFirestore

final class FirestoreShopManager: ObservableObject {
    static let shared = FirestoreShopManager()
    @Published var shops: [Shop] = []
    
    private init() {
        fetchAllShops()
    }
    
    func fetchAllShops() {
        let docRef = Firestore.firestore().collection("shops")
        
        docRef.getDocuments { snapshot, error in
            guard error == nil else {
                Logger.firebase.info("\(error?.localizedDescription ?? "")")
                return
            }
            
            self.shops.removeAll()
            
            guard let snapshot = snapshot else {
                Logger.firebase.info("\(#function): No snapshot \(String(describing: error?.localizedDescription))")
                return
            }
            
            for document in snapshot.documents {
                do {
                    let data = try document.data(as: Shop.self)
                    
                    self.shops.append(data)
                } catch {
                    Logger.firebase.info("\(#function) \(error.localizedDescription)")
                }
            }
            
            Logger.firebase.info("Shop fetch success")
        }
    }
}
