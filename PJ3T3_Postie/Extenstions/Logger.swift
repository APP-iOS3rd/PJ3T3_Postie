//
//  Logger.swift
//  PJ3T3_Postie
//
//  Created by KHJ on 2024/02/23.
//

import Foundation
import OSLog

extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier ?? "com.eunicej927.postie"
    static let auth = Logger(subsystem: subsystem, category: "auth")
    static let firebase = Logger(subsystem: subsystem, category: "firebase")
    static let map = Logger(subsystem: subsystem, category: "map")
    static let notification = Logger(subsystem: subsystem, category: "notification")
}
