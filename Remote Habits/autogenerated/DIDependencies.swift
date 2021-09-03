import CioTracking
import Foundation

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

        return CustomerIO(siteId: Env.customerIOSiteId, apiKey: Env.customerIOApiKey, region: region)
    }
}
