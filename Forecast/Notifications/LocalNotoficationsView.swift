//
//  LocalNotoficationsView.swift
//  Forecast
//
//  Created by Alexandra on 11.06.2024.
//

import SwiftUI
import UserNotifications
import CoreLocation

class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    
    static let instance = NotificationManager()
    
    private var lastNotificationDate: Date?
    
    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    func requestAuth() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (success, error) in
            if let error = error {
                print("ERROR: \(error)")
            } else {
                print("SUCCESS")
            }
        }
    }
    
    func scheduleNotification(title: String, subtitle: String) {
        guard shouldScheduleNotification() else { return }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3600, repeats: false)
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.sound = .default
        content.badge = 1
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { [weak self] (error) in
            if let error = error {
                print("Failed to add request: \(error)")
            } else {
                print("Notification scheduled: \(content.title)")
                self?.lastNotificationDate = Date()
            }
        }
    }
    
    private func shouldScheduleNotification() -> Bool {
        if let lastDate = lastNotificationDate {
            let timeInterval = Date().timeIntervalSince(lastDate)
            return timeInterval >= 3600
        }
        return true
    }
    
    func cancelNotification() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound, .badge])
    }
}

extension UNUserNotificationCenter {
    func setBadgeCount(_ count: Int) {
        DispatchQueue.main.async {
            UIApplication.shared.applicationIconBadgeNumber = count
        }
    }
}
