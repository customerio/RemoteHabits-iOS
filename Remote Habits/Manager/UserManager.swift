import Foundation

protocol UserManager {
    var email: String? { get set }
    var apnDeviceToken: Data? { get set }
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

    var apnDeviceToken: Data? {
        get {
            userDefaults.data(forKey: UserDefaultKeys.apnDeviceToken.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: UserDefaultKeys.apnDeviceToken.rawValue)
        }
    }

    var isLoggedIn: Bool {
        email != nil
    }

    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
}
