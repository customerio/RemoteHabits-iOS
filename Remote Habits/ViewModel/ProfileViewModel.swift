import CioTracking
import Foundation

// sourcery: InjectRegister = "ProfileViewModel"
class ProfileViewModel: ObservableObject {
    struct LoggedInProfileState {
        let loggingIn: Bool
        let loggedInProfile: Profile?
        let error: Error?
    }

    private let cioTracking: Tracking
    private let cio: CustomerIO
    private let profileRepository: ProfileRepository

    @Published var loggedInProfileState = LoggedInProfileState(loggingIn: false, loggedInProfile: nil, error: nil)

    init(cioTracking: Tracking, profileRepository: ProfileRepository, cio: CustomerIO) {
        self.cioTracking = cioTracking
        self.profileRepository = profileRepository
        self.cio = cio
    }

    func loginUser(email: String, password: String, firstName: String, generatedRandom: Bool) {
        loggedInProfileState = LoggedInProfileState(loggingIn: true, loggedInProfile: nil, error: nil)

        profileRepository.loginUser(email: email, password: password, firstName: firstName) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success:
                self.loggedInProfileState = LoggedInProfileState(loggingIn: false,
                                                                 loggedInProfile: Profile(email: email), error: nil)

                if generatedRandom {
                    self.cio.track(name: "Name randomly generated") { _ in }
                }
            case .failure(let error):
                self.loggedInProfileState = LoggedInProfileState(loggingIn: false, loggedInProfile: nil, error: error)
            }
        }
    }
}
