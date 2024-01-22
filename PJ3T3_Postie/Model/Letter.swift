//
//  Letter.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 1/17/24.
//

import Foundation
import FirebaseFirestore

struct Letter: Codable, Hashable, Identifiable {
    var id: String
    var writer: String
    var recipient: String
    var summary: String
    var date: Date
    var imageName: String? //이미지 경로 nil 가능여부 체크 필요, Test용 데이터
}
