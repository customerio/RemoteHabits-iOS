import Foundation

protocol UserManager {
    var email: String? { get set }
    var userName : String? {get set}
    var apnDeviceToken: Data? { get set }
    var fcmDeviceToken: String? { get set }
    var isGuestLogin : Bool? {get set}
    var isLoggedIn: Bool { get }
}

// sourcery: InjectRegister = "UserManager"
class AppUserManager: UserManager {
    
    private let userDefaults: UserDefaults

    var userName: String? {
        get {
            userDefaults.string(forKey: UserDefaultKeys.userName.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: UserDefaultKeys.userName.rawValue)
        }
    }

    var isGuestLogin: Bool? {
        get {
            userDefaults.bool(forKey: UserDefaultKeys.guestLogin.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: UserDefaultKeys.guestLogin.rawValue)
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

    var apnDeviceToken: Data? {
        get {
            userDefaults.data(forKey: UserDefaultKeys.apnDeviceToken.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: UserDefaultKeys.apnDeviceToken.rawValue)
        }
    }

    var fcmDeviceToken: String? {
        get {
            userDefaults.string(forKey: UserDefaultKeys.fcmDeviceToken.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: UserDefaultKeys.fcmDeviceToken.rawValue)
        }
    }

    var isLoggedIn: Bool {
        email != nil
    }

    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
}
