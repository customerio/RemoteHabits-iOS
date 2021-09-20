import CioMessagingPush
import CioMessagingPushAPN
import UserNotifications

class NotificationService: UNNotificationServiceExtension {
    private let cioMessagingPush: MessagingPush = DI.shared.messagingPush

    override func didReceive(
        _ request: UNNotificationRequest,
        withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void
    ) {
        cioMessagingPush.didReceive(request, withContentHandler: contentHandler)
    }

    override func serviceExtensionTimeWillExpire() {
        cioMessagingPush.serviceExtensionTimeWillExpire()
    }
}
