import Foundation

struct Profile {
    let email: EmailAddress
}

struct ValidateWorkspaceResponse: Codable {
    let meta: CredMessage?
}

struct CredMessage: Codable {
    let message: String?
    let error: String?
}
