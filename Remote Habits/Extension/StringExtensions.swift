import Foundation

extension String {
    init(apnDeviceToken: Data) {
        // Convert `Data` to `String` for APN device token.
        // [Reference](https://nshipster.com/apns-device-tokens/)
        self = apnDeviceToken.map { String(format: "%02x", $0) }.joined()
    }

    var data: Data! {
        data(using: .utf8)
    }

    static var abcLetters: String {
        "abcdefghijklmnopqrstuvwxyz"
    }

    static var random: String {
        String.random()
    }

    static func random(length: Int = 10) -> String {
        String((0 ..< length).map { _ in abcLetters.randomElement()! })
    }

    func toDate(withFormat format: DateFormat) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        let date = dateFormatter.date(from: self)
        return date
    }

    func isEmpty() -> Bool {
        trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == ""
    }
}

typealias EmailAddress = String

extension EmailAddress {
    static var randomEmail: String {
        "\(String.random)@customer.io"
    }
}
