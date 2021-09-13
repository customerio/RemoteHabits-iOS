import CioTracking
import Firebase
import Foundation
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        FirebaseApp.configure() // run first so crashes are caught before all other initialization.

        // If you have decided to use the shared singleton method of using the Customer.io SDK,
        // initialize the SDK here in the `AppDelegate`.
        CustomerIO.initialize(siteId: "YOUR SITE ID", apiKey: "YOUR API KEY", region: Region.US)

        return true
    }
}
