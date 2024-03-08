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
        do {
            let appleID = 6478052812 //테스트용 다른 앱 아이디: 415597317
            
            guard let currentVersionNumber = Bundle.main.releaseVersionNumber,
                  let url = URL(string: "https://itunes.apple.com/lookup?id=\(appleID)&country=kr"),
                  let data = try? Data(contentsOf: url),
                  let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
                  let results = json["results"] as? [[String: Any]],
                  let appStoreVersionNumber = results[0]["version"] as? String else {
                Logger.version.error("Error: no app with matching bundle ID found")
                return false
            }
            
            Logger.version.info("----> 최신 버전: \(appStoreVersionNumber)")
            Logger.version.info("----> 현재 버전: \(currentVersionNumber)")
            
            let splitLatestVersion = appStoreVersionNumber.split(separator: ".").map { $0 }
            let splitCurrentVersion = currentVersionNumber.split(separator: ".").map { $0 }
            
            //최신버전 첫째자리와 현재 버전 첫째자리 비교
            if splitLatestVersion[0] == splitCurrentVersion[0] {
                //최신버전 둘째자리와 현재 버전 둘째자리 비교
                if splitLatestVersion[1] == splitCurrentVersion[1] {
                    //최신버전 셋째자리와 현재 버전 셋째자리 비교
                    if splitLatestVersion[2] <= splitCurrentVersion[2] {
                        return false
                    } else {
                        Logger.version.info("----> 최신 버전 셋째자리: \(splitLatestVersion[2])")
                        Logger.version.info("----> 현재 버전 셋째자리: \(splitCurrentVersion[2])")
                        return true
                    }
                }
                
                if splitLatestVersion[1] < splitCurrentVersion[1] {
                    return false
                } else {
                    Logger.version.info("----> 최신 버전 둘째자리: \(splitLatestVersion[1])")
                    Logger.version.info("----> 현재 버전 둘째자리: \(splitCurrentVersion[1])")
                    return true
                }
            }
            
            if splitLatestVersion[0] < splitCurrentVersion[0] {
                return false
            } else {
                Logger.version.info("----> 최신 버전 첫째자리: \(splitLatestVersion[0])")
                Logger.version.info("----> 현재 버전 첫째자리: \(splitCurrentVersion[0])")
                return true
            }
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
