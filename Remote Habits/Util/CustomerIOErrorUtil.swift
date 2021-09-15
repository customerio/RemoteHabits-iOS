import CioTracking
import Foundation

protocol CustomerIOErrorUtil {
    @discardableResult
    func parse(_ error: CustomerIOError) -> HumanReadableError
}

// sourcery: InjectRegister = "CustomerIOErrorUtil"
class AppCustomerIOErrorUtil: CustomerIOErrorUtil {
    private let logger: Logger

    init(logger: Logger) {
        self.logger = logger
    }

    func parse(_ error: CustomerIOError) -> HumanReadableError {
        var errorMessage = "Sorry! We found a problem with the app. We have been notified. Please, try again."

        switch error {
        case .noCustomerIdentified:
            logger
                .reportError(message: "Tried to perform an action but can't because no customer is identified.")
        case .notInitialized:
            logger.reportError(message: "Customer.io SDK not intialized.")
        case .http(let error):
            switch error {
            // Bad credentials given to SDK. Log error to fix it.
            case .unauthorized:
                logger.reportError(message: "Customer.io SDK credentials not valid.")
            case .noOrBadNetwork, .noRequestMade:
                errorMessage = "It looks like there is a problem with your Internet connection. Please, try again."
            // An error of the SDK or app developer error. Log to fix it.
            case .urlConstruction, .unsuccessfulStatusCode:
                logger.reportError(error: error)
            // Cancelled requests are bad in that the request was not successful. However, it could also be
            // because the user left a screen and garbage collected the object making the request.
            case .cancelled: break
            }
        // Misc error of the SDK. Log it in case need to report to SDK developers.
        case .underlying(let error):
            logger.reportError(error: error)
        }

        return HumanReadableError(message: errorMessage)
    }
}
