import CioMessagingPushAPN
import CioTracking
import UserNotifications

class NotificationService: UNNotificationServiceExtension {
    override func didReceive(_ request: UNNotificationRequest,
                             withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void)
    {
        // Adding temporary workaround for the issue https://github.com/customerio/customerio-ios/issues/159
        // This should be removed once the fix has been made.
        CustomerIO
            .initialize(siteId: Env.customerIOSiteId, apiKey: Env.customerIOApiKey, region: Region.US) { config in }

        // If you use more service then Customer.io for sending rich push messages,
        // you can check if the SDK handled the rich push for you. If it did not, you
        // know that the push was *not* sent by Customer.io and you can try another way.
        let handled = MessagingPush.shared.didReceive(request, withContentHandler: contentHandler)
        if !handled {
            // Either the push was *not* sent by Customer.io or the push is not a rich push.
            // Give the push request to another SDK that you use, handle it yourself, or complete.
            contentHandler(request.content)
        }

        /**
         // If you have a use case where you need to also modify the push notification
         // content, you can set your own completion handler.
         cioMessagingPush.didReceive(request) { notificationContent in
             if let mutableContent = notificationContent.mutableCopy() as? UNMutableNotificationContent {
                 // Modify the push notification.
             }

             contentHandler(notificationContent)
         }
          */
    }

    override func serviceExtensionTimeWillExpire() {
        MessagingPush.shared.serviceExtensionTimeWillExpire()
    }
}
