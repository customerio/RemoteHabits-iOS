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
//        // Set FCM messaging delegate
//        Messaging.messaging().delegate = self
//
//        // It's good practice to always register for remote push when the app starts.
//        // This asserts that the Customer.io SDK always has a valid APN device token to use.
//        UIApplication.shared.registerForRemoteNotifications()
//
//        return true
//    }
// }
//
// extension AppDelegateFCM: MessagingDelegate {
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//        guard let fcmToken = fcmToken else { return }
//
//        let cioMessagingPush = DI.shared.messagingPush
//        let logger = DI.shared.logger
//        let cioErrorUtil = DI.shared.customerIOErrorUtil
//        var userManager = DI.shared.userManager
//
//        // At this time, the Customer.io SDK does not save APN device tokens to a customer profile for you.
//        // So, we are saving the device token for later when a profile is identified in the app to register
//        // a device token to the profile then.
//        userManager.fcmDeviceToken = fcmToken
//
//        // Customer.io SDK will return an error when attempting to register a device token if a profile has
//        // not been identified with Customer.io yet. Therefore, we check if a profile has been identified yet.
//        guard userManager.isLoggedIn else {
//            return
//        }
//
//        cioMessagingPush
//            .messaging(messaging, didReceiveRegistrationToken: fcmToken) { result in
//                switch result {
//                case .success:
//                    logger.log("Successfully registered device push token")
//                case .failure(let cioError):
//                    cioErrorUtil.parse(cioError)
//                }
//            }
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