//
//  MapViewMoel.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 1/17/24.
//

import CoreLocation
import Foundation
import NMapsMap
import SwiftUI
import XMLCoder

//공공데이터 API를 담은 구조체
struct PostListResponse: Codable {
    let postMsgHeader: PostMsgHeader
    let postItems: [PostItem]
    
    private enum CodingKeys: String, CodingKey {
        case postMsgHeader
        case postItems = "postItem"
    }
}

struct PostMsgHeader: Codable {
    let totalCount: Int
    let pageCount: Int // 보여줄 아이템 수 : 최대 50
    let totalPage : Int
    let nowPage: Int
}

struct PostItem: Codable, Hashable {
    let postId: Int
    let postDiv: Int
    let postNm: String // 사용됨
    let postNmEn: String
    let postTel: String
    let postFax: String
    let postAddr: String
    let postAddrEn: String
    let post365Yn: String
    let postTime: String // 사용됨
    let postFinanceTime: String
    let postServiceTime: String?
    let postLat: String // 사용됨
    let postLon: String // 사용됨
    let postSubWay: String
    let postOffiId: Int
    let fundSaleYn: String
    let phoneSaleYn: String
    let partTimeYn: String
    let lunchTimeYn: String
    let lunchTime: String?
    let todayDepartureYn: String
    let todayDepartureMailTime: String
    let postDesc: String?
    let modDt: String
}

//NaverMap에서 만들어지는 구조체 / 주소를 위,경도로 바꾸는 값 포함
struct GeocodeResponse: Decodable {
    let status: String
    let addresses: [Address]
}

struct Address: Decodable {
    let roadAddress: String
    let jibunAddress: String
    let x: String
    let y: String
}

//내가 정말 필요한 값 주소, 위도, 경도
struct CombinedResult: Decodable, Hashable {
    let latitude: String
    let longitude: String
    let address: String
}

