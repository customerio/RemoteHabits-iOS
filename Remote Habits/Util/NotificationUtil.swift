import Foundation
import UserNotifications

protocol NotificationUtil {
    func requestShowLocalNotifications()
}

// sourcery: InjectRegister = "NotificationUtil"
class AppNotificationUtil: NotificationUtil {
    // If you want to display a push notification UI, you call this function to ask permission.
    // A popup will show up by the OS to ask for permission. Permission may get denied.
    // If you are only interested in silent pushes and not showing a UI, enable the ability for
    // background modes: https://stackoverflow.com/a/46728144 and then in your APN payload add:
    // "aps": { "content-available" : 1 ... }
    // Silent pushes need not call this function.
    func requestShowLocalNotifications() {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound] // Options: .alert, .badge, .sound
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { _, _ in })
    }
}
