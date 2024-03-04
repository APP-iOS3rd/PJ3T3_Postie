//
//  AppStoreUpdateChecker.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 2/22/24.
//

import Foundation
import OSLog

struct AppStoreUpdateChecker {
    static func isNewVersionAvailable() async -> Bool {
//        let bundleID = "com.iloen.iphonemelon" //코드 테스트시 12행 활성화, 14행은 주석처리
//        guard
//            let bundleID = Bundle.main.bundleIdentifier,
//            let countryCode = Locale.current.language.region?.identifier,
//            let url = URL(string: "https://itunes.apple.com/lookup?bundleId=\(bundleID)&country=\(countryCode)"),
//            let currentVersionNumber = Bundle.main.releaseVersionNumber
//        else {
//            Logger.version.error("bunldeID 또는 countryCode 찾지 못함")
//            return false
//        }

        do {
            let appleID = 6478052812 //415597317
            
            guard let currentVersionNumber = Bundle.main.releaseVersionNumber,
                  let url = URL(string: "https://itunes.apple.com/lookup?id=\(appleID)&country=kr"),
                  let data = try? Data(contentsOf: url),
                  let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
                  let results = json["results"] as? [[String: Any]],
                  let appStoreVersionNumber = results[0]["version"] as? String else {
                Logger.version.error("Error: no app with matching bundle ID found")
                return false
            }
            
            Logger.version.info("---> url: \(url)")
            
            /*버전 1.1.0부터는 셋쩨자리를 비교해서 업데이트 하도록 하면 좋을 것 같아 작성한 코드입니다.
             지금은 모든 패치가 중요할 수 있어 우선 모든 업데이트마다 알림을 뜨게 하였습니다. */
            let splitLatestVersion = appStoreVersionNumber.split(separator: ".").map { $0 }
            let splitCurrentVersion = currentVersionNumber.split(separator: ".").map { $0 }
            
            if splitLatestVersion[0] > splitCurrentVersion[0] {
                print("----> 최신 버전 첫째자리:", splitLatestVersion[0])
                print("----> 현재 버전 첫째자리:", splitCurrentVersion[0])
                return true
            } else if splitLatestVersion[1] > splitCurrentVersion[1] {
                print("----> 최신 버전 둘째자리:", splitLatestVersion[1])
                print("----> 현재 버전 둘째자리:", splitCurrentVersion[1])
                return true
            } else if splitLatestVersion[2] > splitCurrentVersion[2] {
                print("----> 최신 버전 셋째자리:", splitLatestVersion[2])
                print("----> 현재 버전 셋째자리:", splitCurrentVersion[2])
                return true
            }
            
            Logger.version.info("----> 최신 버전: \(appStoreVersionNumber)")
            Logger.version.info("----> 현재 버전: \(currentVersionNumber)")
            
            // Checks if there's a mismatch in version numbers
            return false
        } catch {
            Logger.version.error("버전 찾지 못함: \(error)")
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
