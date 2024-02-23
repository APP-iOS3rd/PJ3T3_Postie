//
//  PJ3T3_PostieApp.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 1/15/24.
//

import SwiftUI
import FirebaseCore
import NMapsMap

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        FirebaseApp.configure()
        
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.list, .banner, .badge, .sound])
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Defult Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) { }
}

@main
struct PJ3T3_PostieApp: App {
    @Environment(\.scenePhase) var scenePhase
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @AppStorage("isThemeGroupButton") private var isThemeGroupButton: Int = 0
    
    private var clientID: String? {
        get { getValueOfPlistFile("MapApiKeys", "NAVER_GEOCODE_ID") }
    }
    
    init() {
        NMFAuthManager.shared().clientId = clientID
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .tint(ThemeManager.themeColors[isThemeGroupButton].tabBarTintColor)
                .customOnChange(scenePhase) { newPhase in
                    if newPhase == .active {
                        UNUserNotificationCenter.current().setBadgeCount(0) { error in
                            guard let error else {
                              // Badge count was successfully updated
                              return
                            }
                            // Replace this with proper error handling
                            print("Failed to reset badge count: \(error)")
                          }
                    }
                }
        }
    }
}
