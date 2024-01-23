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
    let postNm: String
    let postNmEn: String
    let postTel: String
    let postFax: String
    let postAddr: String
    let postAddrEn: String
    let post365Yn: String
    let postTime: String
    let postFinanceTime: String
    let postServiceTime: String?
    let postLat: String
    let postLon: String
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

class OfficeInfoServiceAPI: ObservableObject {
    static let shared = OfficeInfoServiceAPI()
    
    @Published var infos = [PostItem]()
//    @Published var officeMarkers = [OfficeMarker]()
    
    private var apiKey: String? {
        get { getValueOfPlistFile("MapApiKeys", "OFFICE_MAIN_KEY")}
    }
    
    func fetchData() {
        guard let apiKey = apiKey else { return }
        
        //postDivType 데이터 대상 null=전체대상, 1=우체국, 2=우체통
        //postGap 반경 코드 1km = 1, 0.5km = 0.5
        let urlString = "https://www.koreapost.go.kr/koreapost/openapi/searchPostScopeList.do?serviceKey=\(apiKey)&postLatitude=37.56&postLongitude=126.98&postGap=0.5&postDivType=2"
        print(apiKey)
        
        //URL주소로 받아와 지면 값을 url로 저장해라
        //url설정 부터 str까진 공통 작업
        guard let url = URL(string: urlString) else { return }
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            let str = String(decoding: data, as: UTF8.self)
            print(str)
            
            do {
                let postListResponse = try XMLDecoder().decode(PostListResponse.self, from: data)
                DispatchQueue.main.async {
                    self.infos = postListResponse.postItems
//                    self.updateOfficeMarkers()
                }
                print(postListResponse.postItems)
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    private init() {}
}
