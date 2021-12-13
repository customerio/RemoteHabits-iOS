// Generated using Sourcery 1.6.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable all

import Foundation
import CioTracking
import CioMessagingPush
import CioMessagingPushAPN
import CioMessagingPushFCM

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
    case trackRepository
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
     static var shared: DI = DI()
    private var overrides: [Dependency: Any] = [:]
    private init() {
    }

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
            case .customerIOErrorUtil: return self.customerIOErrorUtil as! T 
            case .logger: return self.logger as! T 
            case .notificationUtil: return self.notificationUtil as! T 
            case .profileRepository: return self.profileRepository as! T 
            case .trackRepository: return self.trackRepository as! T 
            case .userManager: return self.userManager as! T 
            case .customerIO: return self.customerIO as! T 
            case .messagingPush: return self.messagingPush as! T 
            case .profileViewModel: return self.profileViewModel as! T 
            case .trackerViewModel: return self.trackerViewModel as! T 
            case .tracking: return self.tracking as! T 
            case .userDefaults: return self.userDefaults as! T 
        }
    }

    /**
    Use the property accessors below to inject pre-typed dependencies. 
    */

    // CustomerIOErrorUtil
    internal var customerIOErrorUtil: CustomerIOErrorUtil {    
        if let overridenDep = self.overrides[.customerIOErrorUtil] {
            return overridenDep as! CustomerIOErrorUtil
        }
        return self.newCustomerIOErrorUtil
    }
    private var newCustomerIOErrorUtil: CustomerIOErrorUtil {    
        return AppCustomerIOErrorUtil(logger: self.logger)
    }
    // Logger
    internal var logger: Logger {    
        if let overridenDep = self.overrides[.logger] {
            return overridenDep as! Logger
        }
        return self.newLogger
    }
    private var newLogger: Logger {    
        return AppLogger()
    }
    // NotificationUtil
    internal var notificationUtil: NotificationUtil {    
        if let overridenDep = self.overrides[.notificationUtil] {
            return overridenDep as! NotificationUtil
        }
        return self.newNotificationUtil
    }
    private var newNotificationUtil: NotificationUtil {    
        return AppNotificationUtil()
    }
    // ProfileRepository
    internal var profileRepository: ProfileRepository {    
        if let overridenDep = self.overrides[.profileRepository] {
            return overridenDep as! ProfileRepository
        }
        return self.newProfileRepository
    }
    private var newProfileRepository: ProfileRepository {    
        return AppProfileRepository(cio: self.customerIO, cioErrorUtil: self.customerIOErrorUtil, userManager: self.userManager, messagingPush: self.messagingPush)
    }
    // TrackRepository
    internal var trackRepository: TrackRepository {    
        if let overridenDep = self.overrides[.trackRepository] {
            return overridenDep as! TrackRepository
        }
        return self.newTrackRepository
    }
    private var newTrackRepository: TrackRepository {    
        return AppTrackRepository(cio: self.customerIO, cioErrorUtil: self.customerIOErrorUtil, userManager: self.userManager)
    }
    // UserManager
    internal var userManager: UserManager {    
        if let overridenDep = self.overrides[.userManager] {
            return overridenDep as! UserManager
        }
        return self.newUserManager
    }
    private var newUserManager: UserManager {    
        return AppUserManager(userDefaults: self.userDefaults)
    }
    // CustomerIO (custom. property getter provided via extension)
    internal var customerIO: CustomerIO {    
        if let overridenDep = self.overrides[.customerIO] {
            return overridenDep as! CustomerIO
        }
        return self.customCustomerIO
    }
    // MessagingPush (custom. property getter provided via extension)
    internal var messagingPush: MessagingPush {    
        if let overridenDep = self.overrides[.messagingPush] {
            return overridenDep as! MessagingPush
        }
        return self.customMessagingPush
    }
    // ProfileViewModel
    internal var profileViewModel: ProfileViewModel {    
        if let overridenDep = self.overrides[.profileViewModel] {
            return overridenDep as! ProfileViewModel
        }
        return self.newProfileViewModel
    }
    private var newProfileViewModel: ProfileViewModel {    
        return ProfileViewModel(cio: self.customerIO, profileRepository: self.profileRepository, notificationUtil: self.notificationUtil)
    }
    // TrackerViewModel
    internal var trackerViewModel: TrackerViewModel {    
        if let overridenDep = self.overrides[.trackerViewModel] {
            return overridenDep as! TrackerViewModel
        }
        return self.newTrackerViewModel
    }
    private var newTrackerViewModel: TrackerViewModel {    
        return TrackerViewModel(cio: self.customerIO, trackRepository: self.trackRepository)
    }
    // Tracking (custom. property getter provided via extension)
    internal var tracking: Tracking {    
        if let overridenDep = self.overrides[.tracking] {
            return overridenDep as! Tracking
        }
        return self.customTracking
    }
    // UserDefaults (custom. property getter provided via extension)
    internal var userDefaults: UserDefaults {    
        if let overridenDep = self.overrides[.userDefaults] {
            return overridenDep as! UserDefaults
        }
        return self.customUserDefaults
    }
}
