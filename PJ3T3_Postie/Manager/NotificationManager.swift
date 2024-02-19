//
//  NotificationManager.swift
//  PJ3T3_Postie
//
//  Created by Eunsu JEONG on 2/19/24.
//

import UserNotifications
import UIKit

struct Notification {
    var id: String
    var title: String
    var body: String
}

class NotificationManager {
    static let shared = NotificationManager()
    let notificationCenter = UNUserNotificationCenter.current()
    var notifications = [Notification]()
    
    private init() { }
    
    /// 알림 권한이 있으면 바로 알림을 추가하고 권한이 없으면 권한을 요청한다. 편지 저장하는 버튼의 마지막 단계에 연결하면 좋을 듯 하다.
    func setNotification(date: Date) {
        notificationCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestPermission()
            case .authorized, .provisional:
                DispatchQueue.main.async {
                    self.scheduleNotifications(date: date)
                }
            default:
                break
            }
        }
    }
    
    /// 뱃지, 사운드, 알림에 대한 권한을 요청한다.
    func requestPermission() {
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                if granted == true && error == nil { }
            }
    }
    
    /// 알림을 추가한다.
    func addNotification(id: String, title: String, body: String) {
        notifications.append(Notification(id: id, title: title, body: body))
    }
    
    ///날짜를 파라미터로 받아 알람을 설정한다.
    func scheduleNotifications(date: Date) {
        for notification in notifications {
            let content = UNMutableNotificationContent()
            content.title = notification.title
            content.body = notification.body
            content.sound = .default
            content.badge = NSNumber(value: UIApplication.shared.applicationIconBadgeNumber + 1)
            
            let date = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)
            let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)
            
            notificationCenter.add(request) { error in
                    guard error == nil else {
                        print(#function, "Failed to schedule notification", error)
                        return
                    }
                    print("Scheduling notification with id: \(notification.id)")
                }
        }
    }
    
    ///아직 전달되지 않은 알림이 있는지 확인한다.
    func checkPendingNotifications() {
        notificationCenter.getPendingNotificationRequests { requests in
            for request in requests {
                print(#function, request.identifier)
            }
        }
    }
    
    ///docId를 input 받아 알림을 삭제한다.
    func removePendingNotificationRequests(docId: String) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [docId])
    }
}
