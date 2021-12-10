import Foundation

protocol UserManager {
    var email: String? { get set }
    var isLoggedIn: Bool { get }
}

// sourcery: InjectRegister = "UserManager"
class AppUserManager: UserManager {
    private let userDefaults: UserDefaults

    var email: String? {
        get {
            userDefaults.string(forKey: UserDefaultKeys.loggedInUserEmail.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: UserDefaultKeys.loggedInUserEmail.rawValue)
        }
    }

    var isLoggedIn: Bool {
        email != nil
    }

    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
}
