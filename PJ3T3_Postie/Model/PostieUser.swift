//
//  PostieUser.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 2/1/24.
//

import Foundation

struct PostieUser: Identifiable, Codable {
    let id: String
    let fullName: String
    let nickname: String
    let email: String
    let profileImageUrl: String?
}
