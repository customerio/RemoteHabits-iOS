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
    private let profileRepository: ProfileRepository
    private let notificationUtil: NotificationUtil

    @Published var loggedInProfileState = LoggedInProfileState(loggingIn: false, loggedInProfile: nil, error: nil)
    
    init(cio: CustomerIO, profileRepository: ProfileRepository, notificationUtil: NotificationUtil) {
        self.cio = cio
        self.profileRepository = profileRepository
        self.notificationUtil = notificationUtil
    }

    func loginUser(email: String, password: String, firstName: String, generatedRandom: Bool) {
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
                    self.cio.track(name: "Name randomly generated", data: ["foo": "bar"])
                }
            case .failure(let error):
                self.loggedInProfileState = LoggedInProfileState(loggingIn: false, loggedInProfile: nil, error: error)
            }
        }
    }
}
