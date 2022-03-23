import CioMessagingPushAPN
import UserNotifications

class NotificationService: UNNotificationServiceExtension {
    private let cioMessagingPush: MessagingPush = DI.shared.messagingPush

    override func didReceive(
        _ request: UNNotificationRequest,
        withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void
    ) {
        // If you use more service then Customer.io for sending rich push messages,
        // you can check if the SDK handled the rich push for you. If it did not, you
        // know that the push was *not* sent by Customer.io and you can try another way.
        let handled = cioMessagingPush.didReceive(request, withContentHandler: contentHandler)
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
        cioMessagingPush.serviceExtensionTimeWillExpire()
    }
}
