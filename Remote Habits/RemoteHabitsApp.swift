import SwiftUI

@main
struct RemoteHabitsApp: App {
    /**
     Here, decide what `AppDelegate` that you would like to use for the app.
     1. AppDelegate - use for APN push service
     2. AppDelegateFCM - use for FCM push service
     */
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    // @UIApplicationDelegateAdaptor(AppDelegateFCM.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
