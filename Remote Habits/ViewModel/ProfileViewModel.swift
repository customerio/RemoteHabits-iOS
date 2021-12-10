import CioTracking
import Foundation

// sourcery: InjectRegister = "ProfileViewModel"
class ProfileViewModel: ObservableObject {
    struct LoggedInProfileState {
        let loggingIn: Bool
        let loggedInProfile: Profile?
        let error: Error?
    }

    private let cio: CustomerIO
    private var userManager = DI.shared.userManager
    private let profileRepository: ProfileRepository
    private let notificationUtil: NotificationUtil
    @Published var loggedInProfileState = LoggedInProfileState(loggingIn: false, loggedInProfile: nil, error: nil)
    
    init(cio: CustomerIO, profileRepository: ProfileRepository, notificationUtil: NotificationUtil) {
        self.cio = cio
        self.profileRepository = profileRepository
        self.notificationUtil = notificationUtil
    }

    func loginUser(email: String, password: String, firstName: String, generatedRandom: Bool, completion: @escaping ((Bool) -> Void)) {
        loggedInProfileState = LoggedInProfileState(loggingIn: true, loggedInProfile: nil, error: nil)

        profileRepository.loginUser(email: email, password: password, firstName: firstName) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success:
                // Now that we have successfully identified a profile in the Customer.io SDK, we can safely
                // register for APN push notifications so the device token is registered to a Customer.io profile.
                self.notificationUtil.requestShowLocalNotifications()

                self.loggedInProfileState = LoggedInProfileState(loggingIn: false,
                                                                 loggedInProfile: Profile(email: email), error: nil)

                if generatedRandom {
                    
                    // At this time, the Customer.io SDK does not handle errors that occur when tracking events.
                    // If an error happens such as device being in airplane mode, you will lose that data.
                    // However, for some apps whose customers are almost always online this may not be very risky
                    // for you to do and you can simply not have any error handling like below.
                    self.cio.track(name: "Name randomly generated", data: ["foo": "bar"])
                }
                completion(true)
            case .failure(let error):
                print(error)
                self.loggedInProfileState = LoggedInProfileState(loggingIn: false, loggedInProfile: nil, error: error)
                completion(false)
            }
        }
    }
    
    func logoutUser() {
        userManager.email = nil
        userManager.userName = nil
        userManager.isGuestLogin = nil
        profileRepository.logoutUser()
    }
}
