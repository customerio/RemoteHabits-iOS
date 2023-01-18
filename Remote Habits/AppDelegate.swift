import CioMessagingInApp
import CioMessagingPushAPN
import CioTracking
import CoreData
import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var userManager = DI.shared.userManager
    let logger = DI.shared.logger

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        // Step 1: Initialise CustomerIO SDK and all of it's modules used in this app
        initializeCustomerIOSdk()

        // Step 2: To display rich push notification
        UNUserNotificationCenter.current().delegate = self

        // Step 3: Register for push notifications
        UIApplication.shared.registerForRemoteNotifications()

        // In-app
        MessagingInApp.shared.initialize(organizationId: Env.customerIOInAppOrganizationId, eventListener: self)

        return true
    }

    public func initializeCustomerIOSdk(configHandler overrideConfigHandler: ((inout CioSdkConfig) -> Void)? = nil) {
        let workspaceId = userManager.workspaceID ?? Env.customerIOSiteId
        let apiKey = userManager.apiKey ?? Env.customerIOApiKey

        let configHandler = overrideConfigHandler ?? { config in
            config.logLevel = .debug
            config.autoTrackScreenViews = true
        }

        // Step 1: Initialise CustomerIO SDK
        CustomerIO.initialize(siteId: workspaceId, apiKey: apiKey, region: Region.US, configure: configHandler)

        // Initialize in-app module
        MessagingInApp.initialize(organizationId: Env.customerIOInAppOrganizationId)
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running,
        // this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // PUSH NOTIFICATIONS
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        MessagingPush.shared.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        MessagingPush.shared.application(application, didFailToRegisterForRemoteNotificationsWithError: error)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let handled = MessagingPush.shared.userNotificationCenter(center, didReceive: response,
                                                                  withCompletionHandler: completionHandler)

        // If the Customer.io SDK does not handle the push, it's up to you to handle it and call the
        // completion handler. If the SDK did handle it, it called the completion handler for you.
        if !handled {
            completionHandler()
        }
    }

    // OPTIONAL: If you want your push UI to show even with the app in the foreground, override this function and call
    // the completion handler.
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
                                    -> Void) {
        completionHandler([.list, .banner, .badge, .sound])
    }
}

extension AppDelegate: InAppEventListener {
    func messageShown(message: InAppMessage) {
        logger.log("in-app message shown. message: \(message)")
    }

    func messageDismissed(message: InAppMessage) {
        logger.log("in-app message dismissed. message: \(message)")
    }

    func errorWithMessage(message: InAppMessage) {
        logger.log("error with in-app message. message: \(message)")
    }

    func messageActionTaken(message: InAppMessage, currentRoute: String, action: String,
                            name: String) {
        logger
            .log("in-app message action taken. current route: \(currentRoute), action: \(action), name: \(name), message: \(message)")
    }
}
