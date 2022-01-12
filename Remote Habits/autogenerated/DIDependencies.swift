import CioMessagingPush
import CioTracking
import Foundation
import UIKit

// sourcery: InjectRegister = "Tracking"
// sourcery: InjectCustom
extension Tracking {}

extension DI {
    var customTracking: Tracking {
        Tracking(customerIO: customerIO)
    }
}

// sourcery: InjectRegister = "CustomerIO"
// sourcery: InjectCustom
extension CustomerIO {}

extension DI {
    var customCustomerIO: CustomerIO {
        let region = Env.customerIORegion == "us" ? Region.US : Region.EU

        let cio = CustomerIO(siteId: Env.customerIOSiteId, apiKey: Env.customerIOApiKey, region: region)

        cio.config {
            $0.logLevel = .debug
        }

        return cio
    }
}

// sourcery: InjectRegister = "MessagingPush"
// sourcery: InjectCustom
extension MessagingPush {}

extension DI {
    var customMessagingPush: MessagingPush {
        MessagingPush(customerIO: DI.shared.customerIO)
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
