import Foundation

/**
 Error that displays a given message. Can be subclassed.
 */
class MessageError: Error {
    let message: String

    init(message: String) {
        self.message = message
    }
}

extension MessageError: CustomStringConvertible, LocalizedError {
    var description: String {
        message
    }

    var errorDescription: String? {
        message
    }
}
