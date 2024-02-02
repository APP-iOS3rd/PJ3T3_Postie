//
//  Shop.swift
//  PJ3T3_Postie
//
//  Created by 권운기 on 1/31/24.
//

import Foundation

struct Shop: Identifiable, Hashable, Codable {
    var id: String
    var shopUrl: String
    var thumbUrl: String
    var title: String
    var category: String
}
