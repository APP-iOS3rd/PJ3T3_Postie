//
//  GoogleUser.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 2/1/24.
//

import Foundation

struct GoogleUser: Encodable {
    let idToken: String
    let accessToken: String
    let name: String?
    let email: String?
    let imageURL: String?
}
