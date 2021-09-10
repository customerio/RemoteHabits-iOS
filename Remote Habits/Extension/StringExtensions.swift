import Foundation

extension String {
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
}

typealias EmailAddress = String

extension EmailAddress {
    static var randomEmail: String {
        "\(String.random)@customer.io"
    }
}
