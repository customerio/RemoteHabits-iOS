import Foundation

protocol UserManager {
    var email: String? { get set }
    var userName: String? { get set }
    var workspaceID: String? { get set }
    var apiKey: String? { get set }
    var isLoggedIn: Bool { get }
}

// sourcery: InjectRegister = "UserManager"
class AppUserManager: UserManager {
    private let userDefaults: UserDefaults

    var apiKey: String? {
        get {
            userDefaults.string(forKey: UserDefaultKeys.apiKey.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: UserDefaultKeys.apiKey.rawValue)
        }
    }

    var workspaceID: String? {
        get {
            userDefaults.string(forKey: UserDefaultKeys.workspaceId.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: UserDefaultKeys.workspaceId.rawValue)
        }
    }

    var userName: String? {
        get {
            userDefaults.string(forKey: UserDefaultKeys.userName.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: UserDefaultKeys.userName.rawValue)
        }
    }

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
