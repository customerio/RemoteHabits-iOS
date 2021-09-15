import Foundation
import UserNotifications

protocol NotificationUtil {
    func requestShowLocalNotifications()
}

// sourcery: InjectRegister = "NotificationUtil"
class AppNotificationUtil: NotificationUtil {
    func requestShowLocalNotifications() {
        // If you want to display a push notification UI, you must call the following 2 lines.
        // a popup will show up by the OS to ask for permission. permission may get denied.
        // If you are only interested in silent pushes and not showing a UI, enable the ability for
        // background modes: https://stackoverflow.com/a/46728144 and then in your APN payload add:
        // "aps": { "content-available" : 1 ... }
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound] // Options: .alert, .badge, .sound
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { _, _ in })
    }
}
