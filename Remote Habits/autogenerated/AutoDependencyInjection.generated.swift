// Generated using Sourcery 1.6.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable all

import CioMessagingPush
import CioTracking
import Foundation

// File generated from Sourcery-DI project: https://github.com/levibostian/Sourcery-DI
// Template version 1.0.0

/**
 ######################################################
 Documentation
 ######################################################

 This automatically generated file you are viewing is a dependency injection graph for your app's source code.
 You may be wondering a couple of questions.

 1. How did this file get generated? Answer --> https://github.com/levibostian/Sourcery-DI#how
 2. Why use this dependency injection graph instead of X other solution/tool? Answer --> https://github.com/levibostian/Sourcery-DI#why-use-this-project
 3. How do I add dependencies to this graph file? Follow one of the instructions below:
 * Add a non singleton class: https://github.com/levibostian/Sourcery-DI#add-a-non-singleton-class
 * Add a generic class: https://github.com/levibostian/Sourcery-DI#add-a-generic-class
 * Add a singleton class: https://github.com/levibostian/Sourcery-DI#add-a-singleton-class
 * Add a class from a 3rd party library/SDK: https://github.com/levibostian/Sourcery-DI#add-a-class-from-a-3rd-party
 * Add a `typealias` https://github.com/levibostian/Sourcery-DI#add-a-typealias

 4. How do I get dependencies from the graph in my code?
 ```
 // If you have a class like this:
 class OffRoadWheels {}

 class ViewController: UIViewController {
     // Call the property getter to get your dependency from the graph:
     let wheels = DI.shared.offRoadWheels
     // note the name of the property is name of the class with the first letter lowercase.

     // you can also use this syntax instead:
     let wheels: OffRoadWheels = DI.shared.inject(.offRoadWheels)
     // although, it's not recommended because `inject()` performs a force-cast which could cause a runtime crash of your app.
 }
 ```

 5. How do I use this graph in my test suite?
 ```
 let mockOffRoadWheels = // make a mock of OffRoadWheels class
 DI.shared.override(.offRoadWheels, mockOffRoadWheels)
 ```

 Then, when your test function finishes, reset the graph:
 ```
 DI.shared.resetOverrides()
 ```

 */

/**
 enum that contains list of all dependencies in our app.
 This allows automated unit testing against our dependency graph + ability to override nodes in graph.
 */
enum Dependency: CaseIterable {
    case customerIOErrorUtil
    case logger
    case notificationUtil
    case profileRepository
    case userManager
    case customerIO
    case messagingPush
    case profileViewModel
    case trackerViewModel
    case tracking
    case userDefaults
}

/**
 Dependency injection graph specifically with dependencies in the  module.

 We must use 1+ different graphs because of the hierarchy of modules in this SDK.
 Example: You can't add classes from `Tracking` module in `Common`'s DI graph. However, classes
 in `Common` module can be in the `Tracking` module.
 */
class DI {
    static var shared: DI = .init()
    private var overrides: [Dependency: Any] = [:]
    private init() {}

    /**
     Designed to be used only in test classes to override dependencies.

     ```
     let mockOffRoadWheels = // make a mock of OffRoadWheels class
     DI.shared.override(.offRoadWheels, mockOffRoadWheels)
     ```
     */
    func override<Value: Any>(_ dep: Dependency, value: Value, forType type: Value.Type) {
        overrides[dep] = value
    }

    /**
     Reset overrides. Meant to be used in `tearDown()` of tests.
     */
    func resetOverrides() {
        overrides = [:]
    }

    /**
     Use this generic method of getting a dependency, if you wish.
     */
    func inject<T>(_ dep: Dependency) -> T {
        switch dep {
        case .customerIOErrorUtil: return customerIOErrorUtil as! T
        case .logger: return logger as! T
        case .notificationUtil: return notificationUtil as! T
        case .profileRepository: return profileRepository as! T
        case .userManager: return userManager as! T
        case .customerIO: return customerIO as! T
        case .messagingPush: return messagingPush as! T
        case .profileViewModel: return profileViewModel as! T
        case .trackerViewModel: return trackerViewModel as! T
        case .tracking: return tracking as! T
        case .userDefaults: return userDefaults as! T
        }
    }

    /**
     Use the property accessors below to inject pre-typed dependencies.
     */

    // CustomerIOErrorUtil
    internal var customerIOErrorUtil: CustomerIOErrorUtil {
        if let overridenDep = overrides[.customerIOErrorUtil] {
            return overridenDep as! CustomerIOErrorUtil
        }
        return newCustomerIOErrorUtil
    }

    private var newCustomerIOErrorUtil: CustomerIOErrorUtil {
        AppCustomerIOErrorUtil(logger: logger)
    }

    // Logger
    internal var logger: Logger {
        if let overridenDep = overrides[.logger] {
            return overridenDep as! Logger
        }
        return newLogger
    }

    private var newLogger: Logger {
        AppLogger()
    }

    // NotificationUtil
    internal var notificationUtil: NotificationUtil {
        if let overridenDep = overrides[.notificationUtil] {
            return overridenDep as! NotificationUtil
        }
        return newNotificationUtil
    }

    private var newNotificationUtil: NotificationUtil {
        AppNotificationUtil()
    }

    // ProfileRepository
    internal var profileRepository: ProfileRepository {
        if let overridenDep = overrides[.profileRepository] {
            return overridenDep as! ProfileRepository
        }
        return newProfileRepository
    }

    private var newProfileRepository: ProfileRepository {
        AppProfileRepository(cio: customerIO, cioErrorUtil: customerIOErrorUtil, userManager: userManager,
                             messagingPush: messagingPush)
    }

    // UserManager
    internal var userManager: UserManager {
        if let overridenDep = overrides[.userManager] {
            return overridenDep as! UserManager
        }
        return newUserManager
    }

    private var newUserManager: UserManager {
        AppUserManager(userDefaults: userDefaults)
    }

    // CustomerIO (custom. property getter provided via extension)
    internal var customerIO: CustomerIO {
        if let overridenDep = overrides[.customerIO] {
            return overridenDep as! CustomerIO
        }
        return customCustomerIO
    }

    // MessagingPush (custom. property getter provided via extension)
    internal var messagingPush: MessagingPush {
        if let overridenDep = overrides[.messagingPush] {
            return overridenDep as! MessagingPush
        }
        return customMessagingPush
    }

    // ProfileViewModel
    internal var profileViewModel: ProfileViewModel {
        if let overridenDep = overrides[.profileViewModel] {
            return overridenDep as! ProfileViewModel
        }
        return newProfileViewModel
    }

    private var newProfileViewModel: ProfileViewModel {
        ProfileViewModel(cio: customerIO, profileRepository: profileRepository, notificationUtil: notificationUtil)
    }

    // TrackerViewModel
    internal var trackerViewModel: TrackerViewModel {
        if let overridenDep = overrides[.trackerViewModel] {
            return overridenDep as! TrackerViewModel
        }
        return newTrackerViewModel
    }

    private var newTrackerViewModel: TrackerViewModel {
        TrackerViewModel(cio: customerIO)
    }

    // Tracking (custom. property getter provided via extension)
    internal var tracking: Tracking {
        if let overridenDep = overrides[.tracking] {
            return overridenDep as! Tracking
        }
        return customTracking
    }

    // UserDefaults (custom. property getter provided via extension)
    internal var userDefaults: UserDefaults {
        if let overridenDep = overrides[.userDefaults] {
            return overridenDep as! UserDefaults
        }
        return customUserDefaults
    }
}
