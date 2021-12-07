// import CioMessagingPushFCM
// import CioTracking
// import Firebase
// import FirebaseMessaging
// import Foundation
// import UIKit
//
// **
// AppDelegate for use with the FCM push service.
//
// Follow the code in this file to learn how to use FCM with the Customer.io SDK.
//
// Find the DEVELOPMENT.md file in this project to learn how to use FCM with this app.
// */
// class AppDelegateFCM: NSObject, UIApplicationDelegate {
//    func application(
//        _ application: UIApplication,
//        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
//    ) -> Bool {
//        FirebaseApp.configure() // run first so crashes are caught before all other initialization.
//
//        // If you have decided to use the shared singleton method of using the Customer.io SDK,
//        // initialize the SDK here in the `AppDelegate`.
//        CustomerIO.initialize(siteId: "YOUR SITE ID", apiKey: "YOUR API KEY", region: Region.US)
//
//        // Must call this function in order for `UNUserNotificationCenterDelegate` functions
//        // to be called.
//        UNUserNotificationCenter.current().delegate = self
//
//        // It's good practice to always register for remote push when the app starts.
//        // This asserts that the Customer.io SDK always has a valid APN device token to use.
//        UIApplication.shared.registerForRemoteNotifications()
//
//        // Set FCM messaging delegate after registering for APN push notifications.
//        Messaging.messaging().delegate = self
//
//        return true
//    }
//
//     func application(_ application: UIApplication,
//                      didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//         let logger = DI.shared.logger
//
//         logger.log("Received APN token: \(String(apnDeviceToken: deviceToken))")
//
//         // because we disabled FCM method swizzling, we need to provide the APN token to the FCM SDK.
//         Messaging.messaging().apnsToken = deviceToken
//     }
// }
//
// extension AppDelegateFCM: MessagingDelegate {
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//        let cioMessagingPush = DI.shared.messagingPush
//
//        cioMessagingPush.messaging(messaging, didReceiveRegistrationToken: fcmToken)
//    }
// }
//
// extension AppDelegateFCM: UNUserNotificationCenterDelegate {
//    func userNotificationCenter(
//        _ center: UNUserNotificationCenter,
//        didReceive response: UNNotificationResponse,
//        withCompletionHandler completionHandler: @escaping () -> Void
//    ) {
//        let cioMessagingPush = DI.shared.messagingPush
//
//        let handled = cioMessagingPush.userNotificationCenter(center, didReceive: response,
//                                                              withCompletionHandler: completionHandler)
//
//        // If the Customer.io SDK does not handle the push, it's up to you to handle it and call the
//        // completion handler. If the SDK did handle it, it called the completion handler for you.
//        if !handled {
//            completionHandler()
//        }
//    }
//
//    // If you want your push UI to show even with the app in the foreground, override this function and call
//    // the completion handler.
//    @available(iOS 10.0, *)
//    func userNotificationCenter(
//        _ center: UNUserNotificationCenter,
//        willPresent notification: UNNotification,
//        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
//    ) {
//        completionHandler([.list, .banner, .badge, .sound])
//    }
// }
