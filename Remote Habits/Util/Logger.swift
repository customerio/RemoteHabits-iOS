import Foundation

protocol Logger {
    func log(_ message: String)
    func reportError(error: Error)
    func reportError(message: String) // we will create an `Error` and report that.
}

// sourcery: InjectRegister = "Logger"
class AppLogger: Logger {
    private let logPrefix = "[RH]"

    func log(_ message: String) {
        print("\(logPrefix) \(message)")
    }

    func reportError(error: Error) {
        print("\(logPrefix) \(error.localizedDescription)")
    }

    func reportError(message: String) {
        reportError(error: DeveloperError(message: message))
    }
}
