//
//  AppStoreUpdateChecker.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 2/22/24.
//

import Foundation

struct AppStoreUpdateChecker {
    static func isNewVersionAvailable() async -> Bool {
//        let bundleID = "com.iloen.iphonemelon"
        guard
            let bundleID = Bundle.main.bundleIdentifier,
            let countryCode = Locale.current.language.region?.identifier,
            let currentVersionNumber = Bundle.main.releaseVersionNumber,
            let url = URL(string: "https://itunes.apple.com/lookup?bundleId=\(bundleID)&country=\(countryCode)")
        else {
            print("bunldeID 또는 countryCode 찾지 못함")
            return false
        }
        print("---> url:", url)
        do {
            // Fetches and parses the response
            let (data, response) = try await URLSession.shared.data(from: url)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                print("badServerResponse")
                throw URLError(.badServerResponse)
            }
            let appStoreResponse = try JSONDecoder().decode(AppStoreResponse.self, from: data)
            
            // Retrieves the version number
            guard let latestVersionNumber = appStoreResponse.results.first?.version else {
                // Error: no app with matching bundle ID found
                print("Error: no app with matching bundle ID found")
                return false
            }
            
            /*버전 1.1.0부터는 셋쩨자리를 비교해서 업데이트 하도록 하면 좋을 것 같아 작성한 코드입니다.
             지금은 모든 패치가 중요할 수 있어 우선 모든 업데이트마다 알림을 뜨게 하였습니다.
            let splitLatestVersion = latestVersionNumber.split(separator: ".").map { $0 }
            let splitCurrentVersion = currentVersionNumber.split(separator: ".").map { $0 }
            
            if splitLatestVersion[0] > splitCurrentVersion[0] {
                print("----> 최신 버전 첫째자리:", splitLatestVersion[0])
                print("----> 현재 버전 첫째자리:", splitCurrentVersion[0])
                return true
            } else if splitLatestVersion[1] > splitCurrentVersion[1] {
                print("----> 최신 버전 둘째자리:", splitLatestVersion[1])
                print("----> 현재 버전 둘째자리:", splitCurrentVersion[1])
                return true
            }
            
            print("----> 최신 버전:", splitLatestVersion)
            print("----> 현재 버전:", splitCurrentVersion)
            // Checks if there's a mismatch in version numbers
            return false
             */
            
            print("----> 최신 버전:", latestVersionNumber)
            print("----> 현재 버전:", currentVersionNumber)
            // Checks if there's a mismatch in version numbers
            return currentVersionNumber != latestVersionNumber
        } catch {
            print("버전 찾지 못함: \(error)")
            return false
        }
    }
}

//MARK: - AppStoreResponse
struct AppStoreResponse: Codable {
    let resultCount: Int
    let results: [AppStoreResult]
}

//MARK: - Result
struct AppStoreResult: Codable {
    let releaseNotes: String
    let releaseDate: String
    let version: String
}

private extension Bundle {
    var releaseVersionNumber: String? {
        infoDictionary?["CFBundleShortVersionString"] as? String
    }
}
