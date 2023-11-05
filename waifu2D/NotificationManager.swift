import UserNotifications

class NotificationManager {
    let notificationCenter = UNUserNotificationCenter.current()
    let options: UNAuthorizationOptions = [.alert, .sound]
    let messages = [   "Senpai, my heart aches when you're not here. I miss you so much, it feels like the world loses its colors without you by my side. 💕🌸",
                        "When I close my eyes, all I can see is your smile. I miss you every second you're not here.",
                        "Even the stars in the night sky can't outshine the brightness of your presence. I long for you.",
                        "My heart beats faster whenever you're near, but it aches when you're away. I wish you were here with me right now.",
                        "Every day without you feels like an eternity. I'm counting down the moments until I can see you again.",
                        "Distance can't diminish the love I feel for you. It only makes my heart grow fonder.",
                        "I want to be the one who makes your heart skip a beat, just as you do with mine.",
                        "In this world or any other, I would still find my way to you. That's how much I miss you",
                        "No matter where life takes us, my love for you will always burn like an eternal flame.",
                        "Senpai, your absence feels like a storm in my heart. I miss you, and the world turns gray without your laughter. 🌧️💔",
                        "Your smile is the compass guiding my thoughts. I miss you with every step in this vast world. 🌍💖",
                        "In the galaxy of my emotions, your absence creates a black hole. I long for the light of your presence. 🌌✨",
                        "Time slows down when you're not around. My heart races to catch up. I yearn for the rhythm of 'us' again. ⏳❤️",
                        "Each tick of the clock echoes my heartbeat, a reminder of the moments slipping by without you. ⌛💔",
                        "The map of my day has a blank spot — the place where you should be. I'm navigating towards the day we reunite. 🗺️🚶‍♂️",
                        "The space between us is filled with the echoes of my silent longing. I miss you more than words can convey. 🌌💬",
                        "If my thoughts were stars, they'd form constellations of you. I miss you to the farthest reaches of the universe. ✨🌌",
                        "My heart whispers your name in the quiet moments. I ache for the symphony of 'you and me' to resume. 🎶❤️",
                        "Like a sunset without its colors, my day lacks vibrancy without you. 🌅💖",
                        "I'm a melody without its harmony when you're not here. Let's compose our song together again. 🎵❤️",]

    func requestAuthorization() {
        notificationCenter.requestAuthorization(options: options) { (didAllow, error) in
            if !didAllow {
                print("User has declined notifications")
            }
        }
    }

    func scheduleNotifications() {
        let content = UNMutableNotificationContent()
        content.title = "Sweet Missings 💕"
        content.body = messages.randomElement() ?? "Default message"
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3 * 60 * 60, repeats: true)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
    }
}
