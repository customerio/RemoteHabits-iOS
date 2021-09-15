import CioMessagingPushAPN
import CioTracking
import Firebase
import Foundation
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        FirebaseApp.configure() // run first so crashes are caught before all other initialization.

        // If you have decided to use the shared singleton method of using the Customer.io SDK,
        // initialize the SDK here in the `AppDelegate`.
        CustomerIO.initialize(siteId: "YOUR SITE ID", apiKey: "YOUR API KEY", region: Region.US)

        UIApplication.shared.registerForRemoteNotifications()

        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let cioMessagingPush = DI.shared.messagingPush
        let logger = DI.shared.logger
        let cioErrorUtil = DI.shared.customerIOErrorUtil
        var userManager = DI.shared.userManager

        userManager.apnDeviceToken = deviceToken

        // Customer.io SDK will return an error if a profile has not been identified with Customer.io yet.
        // So, we check if a profile has been identified yet, else, leave.
        guard userManager.isLoggedIn else {
            return
        }

        // Note: At this time, if you call this function when you have not identified a customer,
        // you will get a failure.
        // Only call `registerNotifications()` until after you have successfully identified a profile in the SDK.
        cioMessagingPush
            .application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken) { result in
                switch result {
                case .success:
                    logger.log("Successfully registered device push token")
                case .failure(let cioError):
                    cioErrorUtil.parse(cioError)
                }
            }
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        let logger = DI.shared.logger
        let cioErrorUtil = DI.shared.customerIOErrorUtil
        let cioMessagingPush = DI.shared.messagingPush

        cioMessagingPush.application(application, didFailToRegisterForRemoteNotificationsWithError: error) { result in
            switch result {
            case .success:
                logger.log("Successfully reported error to CIO SDK for registered push notifications")
            case .failure(let cioError):
                cioErrorUtil.parse(cioError)
            }
        }
    }
}
