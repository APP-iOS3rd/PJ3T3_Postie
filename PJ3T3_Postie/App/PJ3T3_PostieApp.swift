//
//  PJ3T3_PostieApp.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 1/15/24.
//

import SwiftUI
import FirebaseCore
import NMapsMap


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct PJ3T3_PostieApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    private var clientID: String? {
        get { getValueOfPlistFile("MapApiKeys", "NAVER_GEOCODE_ID") }
    }
    
    init() {
        NMFAuthManager.shared().clientId = clientID
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }
    }
}

