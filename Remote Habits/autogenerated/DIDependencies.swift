import CioMessagingPushAPN
import CioTracking
import Foundation
import UIKit

// sourcery: InjectRegister = "CustomerIO"
// sourcery: InjectCustom
extension CustomerIO {}

extension DI {
    var customCustomerIO: CustomerIO {
        CustomerIO.shared
    }
}

// sourcery: InjectRegister = "MessagingPush"
// sourcery: InjectCustom
extension MessagingPush {}

extension DI {
    var customMessagingPush: MessagingPush {
        MessagingPush.shared
    }
}

// sourcery: InjectRegister = "UserDefaults"
// sourcery: InjectCustom
extension UserDefaults {}

extension DI {
    var customUserDefaults: UserDefaults {
        UserDefaults.standard
    }
}
