//
//  OfficialLetter.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 2/15/24.
//

import Foundation

struct OfficialLetter: Identifiable, Hashable, Codable {
    let id: String
    let title: String
    let content: String
}
