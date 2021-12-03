import CioMessagingPush
import CioMessagingPushAPN
import CioTracking
import Firebase
import Foundation
import UIKit

/**
 AppDelegate for use with the APN push service.

 Follow the code in this file to learn how to use APN with the Customer.io SDK.

 If you want to use this file in the Remote Habits app:
 1. Open `RemoteHabitsApp` file and follow the instructions there.
 */
class AppDelegateAPN: NSObject, UIApplicationDelegate {
    private var messagingPush: MessagingPush?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        FirebaseApp.configure() // run first so crashes are caught before all other initialization.

        // If you have decided to use the shared singleton method of using the Customer.io SDK,
        // initialize the SDK here in the `AppDelegate`.
        CustomerIO.initialize(siteId: "YOUR SITE ID", apiKey: "YOUR API KEY", region: Region.US)

        // Must call this function in order for `UNUserNotificationCenterDelegate` functions
        // to be called.
        UNUserNotificationCenter.current().delegate = self

        // It's good practice to always register for remote push when the app starts.
        // This asserts that the Customer.io SDK always has a valid APN device token to use.
        UIApplication.shared.registerForRemoteNotifications()

        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let cioMessagingPush = DI.shared.messagingPush

        cioMessagingPush.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        let cioMessagingPush = DI.shared.messagingPush

        cioMessagingPush.application(application, didFailToRegisterForRemoteNotificationsWithError: error)
    }
}

extension AppDelegateAPN: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let cioMessagingPush = DI.shared.messagingPush
        // If not using the `MessagingPush.shared` singleton instance of the SDK, you need to keep a strong
        // reference to `MessagingPush` to avoid the class being garbage collected before
        // the completionHandler is called.
        messagingPush = cioMessagingPush

        let handled = cioMessagingPush.userNotificationCenter(center, didReceive: response,
                                                              withCompletionHandler: completionHandler)

        // If the Customer.io SDK does not handle the push, it's up to you to handle it and call the
        // completion handler. If the SDK did handle it, it called the completion handler for you.
        if !handled {
            completionHandler()
        }
    }

    // If you want your push UI to show even with the app in the foreground, override this function and call
    // the completion handler.
    @available(iOS 10.0, *)
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.list, .banner, .badge, .sound])
    }
}
