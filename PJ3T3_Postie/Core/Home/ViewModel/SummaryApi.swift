//
//  SummaryApi.swift
//  PJ3T3_Postie
//
//  Created by 권운기 on 2/16/24.
//

import Foundation

struct RequestBody: Codable {
    let document: DocumentObject
    let option: OptionObject
}

struct DocumentObject: Codable {
    let title: String?
    let content: String
}

struct OptionObject: Codable {
    let language: String
    let model: String
    let tone: Int
    let summaryCount: Int
}

struct ApiResponse: Codable {
    let summary: String
}

struct APIErrorResponse: Codable {
    let status: Int
    let error: ErrorDetail
}

struct ErrorDetail: Codable {
    let errorCode: String
    let message: String
}

class APIClient {
    static let shared = APIClient()
    private init() {}
    
    private var apiKey: String? {
        get { getValueOfPlistFile("SummaryApiKeys", "APIKey")}
    }
    
    private var apiKeyID: String? {
        get { getValueOfPlistFile("SummaryApiKeys", "APIKeyID")}
    }
    
    func postRequestToAPI(title: String, content: String) async throws -> String {
        guard let apiKeyID = apiKeyID else { return "" }
        guard let apiKey = apiKey else { return "" }
        let apiEndpoint = "https://naveropenapi.apigw.ntruss.com/text-summary/v1/summarize"

        guard let url = URL(string: apiEndpoint) else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.addValue(apiKeyID, forHTTPHeaderField: "X-NCP-APIGW-API-KEY-ID")
        request.addValue(apiKey, forHTTPHeaderField: "X-NCP-APIGW-API-KEY")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let requestBody = RequestBody(
            document: DocumentObject(title: title, content: content),
            option: OptionObject(language: "ko", model: "general", tone: 0, summaryCount: 1)
        )

        request.httpBody = try JSONEncoder().encode(requestBody)

        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            let decoder = JSONDecoder()
            let errorResponse = try decoder.decode(APIErrorResponse.self, from: data)
                        
            throw URLError(.badServerResponse)
        } else {
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(ApiResponse.self, from: data)
                
                return decodedData.summary
            } catch {
                throw URLError(.badServerResponse)
            }
        }
    }
}

func errorMessage(_ statusCode: Int, errorCode: String) -> String {
    switch (statusCode, errorCode) {
    case (400, "E001"):
        return "빈 문자열 or blank 문자"
    case (400, "E002"):
        return "UTF-8 인코딩 에러"
    case (400, "E003"):
        return "문장이 기준치보다 초과했을 경우"
    case (400, "E100"):
        return "유효한 문장이 부족한 경우"
    case (400, "E101"):
        return "ko, ja 가 아닌 경우"
    case (400, "E102"):
        return "general, news 가 아닌 경우"
    case (400, "E103"):
        return "request body의 json format이 유효하지 않거나 필수 파라미터가 누락된 경우"
    case (400, "E415"):
        return "content-type 에러"
    case (400, "E900"):
        return "예외처리가 안된 경우(Bad Request)"
    case (500, "E501"):
        return "엔드포인트 연결 실패"
    case (500, "E900"):
        return "예외처리가 안된 오류(Server Error)"
    default:
        return "알 수 없는 에러"
    }
}
