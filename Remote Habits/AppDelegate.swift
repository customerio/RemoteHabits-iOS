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

        // It's good practice to always register for remote push when the app starts.
        // This asserts that the Customer.io SDK always has a valid APN device token to use.
        UIApplication.shared.registerForRemoteNotifications()

        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let cioMessagingPush = DI.shared.messagingPush
        let logger = DI.shared.logger
        let cioErrorUtil = DI.shared.customerIOErrorUtil
        var userManager = DI.shared.userManager

        // At this time, the Customer.io SDK does not save APN device tokens to a customer profile for you.
        // So, we are saving the device token for later when a profile is identified in the app to register
        // a device token to the profile then.
        userManager.apnDeviceToken = deviceToken

        // Customer.io SDK will return an error when attempting to register a device token if a profile has
        // not been identified with Customer.io yet. Therefore, we check if a profile has been identified yet.
        guard userManager.isLoggedIn else {
            return
        }

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

        // This will delete the existing push token from the identified profile in Customer.io SDK.
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
