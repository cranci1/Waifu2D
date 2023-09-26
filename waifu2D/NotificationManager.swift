import UIKit
import UserNotifications

class NotificationManager {

    static let shared = NotificationManager()

    private init() {}

    func scheduleNotifications() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if granted {
                self.scheduleRecurringNotifications()
            } else {
                print("Notification permission denied.")
            }
        }
    }

    private func scheduleRecurringNotifications() {
        let content = UNMutableNotificationContent()
        content.sound = UNNotificationSound.default

        // An array of different texts for your notifications
        let notificationTexts = [
                    "Senpai, my heart aches when you're not here. I miss you so much, it feels like the world loses its colors without you by my side. 💕🌸",
                    "When I close my eyes, all I can see is your smile. I miss you every second you're not here. 2",
                    "Even the stars in the night sky can't outshine the brightness of your presence. I long for you.",
                    "My heart beats faster whenever you're near, but it aches when you're away. I wish you were here with me right now.",
                    "Every day without you feels like an eternity. I'm counting down the moments until I can see you again.",
                    "Distance can't diminish the love I feel for you. It only makes my heart grow fonder.",
                    "I want to be the one who makes your heart skip a beat, just as you do with mine.",
                    "In this world or any other, I would still find my way to you. That's how much I miss you",
                    "No matter where life takes us, my love for you will always burn like an eternal flame.",
        ]

        let notificationInterval: TimeInterval = 1 * 60 * 60
        var delay: TimeInterval = 60

        for text in notificationTexts {
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: delay, repeats: true)
            content.title = "Sweet Missings 💕"
            content.body = text

            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { (error) in
                if let error = error {
                    print("Error scheduling notification: \(error.localizedDescription)")
                }
            }

            delay += notificationInterval
        }
    }
}
