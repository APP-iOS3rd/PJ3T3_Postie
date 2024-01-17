//
//  User.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 1/17/24.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    let fullName: String
    let email: String
    
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullName) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }

        return ""
    }
}

extension User {
    static var MOCK_USER = User(id: UUID().uuidString, fullName: "Eunice Jeong", email: "test@gmail.com")
}
