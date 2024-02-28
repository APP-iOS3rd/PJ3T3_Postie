//
//  ShopViewModel.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 1/17/24.
//

import Foundation
import OSLog

import FirebaseFirestore
 
class ShopViewModel: ObservableObject {
     
    @Published var shops = [Shop]()
     
    private var db = Firestore.firestore()
     
    func fetchData() {
        db.collection("shops").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                Logger.firebase.info("No documents")
                return
            }
             
            self.shops = documents.map { (queryDocumentSnapshot) -> Shop in
                let data = queryDocumentSnapshot.data()
                let id = data["id"] as? String ?? ""
                let shopUrl = data["shopUrl"] as? String ?? ""
                let thumbUrl = data["thumbUrl"] as? String ?? ""
                let title = data["title"] as? String ?? ""
                let category = data["category"] as? String ?? ""
                return Shop(id: id, shopUrl: shopUrl, thumbUrl: thumbUrl, title: title, category: category)
            }
        }
    }
}
