import CioMessagingPush
import CioMessagingPushAPN
import CioTracking
import Foundation

protocol ProfileRepository {
    func loginUser(
        email: String,
        password: String,
        firstName: String,
        onComplete: @escaping (Result<Void, HumanReadableError>) -> Void
    )
}

// sourcery: InjectRegister = "ProfileRepository"
class AppProfileRepository: ProfileRepository {
    private let cio: CustomerIO
    private let messagingPush: MessagingPush
    private let cioErrorUtil: CustomerIOErrorUtil
    private var userManager: UserManager

    init(cio: CustomerIO, cioErrorUtil: CustomerIOErrorUtil, userManager: UserManager, messagingPush: MessagingPush) {
        self.cio = cio
        self.cioErrorUtil = cioErrorUtil
        self.userManager = userManager
        self.messagingPush = messagingPush
    }

    /// Simulates a network call and will randomly succeed or fail to cover both use cases of the app.
    func loginUser(email: String,
                   password: String,
                   firstName: String,
                   onComplete: @escaping (Result<Void, HumanReadableError>) -> Void) {
        /// simulate a network call by sleeping and then performing action
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }

            let diceRoll = Int.random(in: 0 ..< 100)

            if diceRoll < 90 { // successful login!
                self.userManager.email = email

                self.cio.identify(identifier: email, body: ["first_name": firstName])

                DispatchQueue.main.async {
                    onComplete(.success(()))
                }
            } else { // failed login
                DispatchQueue.main.async {
                    // As an error, for demo purposes let's always make it that you don't have Internet connection.
                    onComplete(.failure(HumanReadableError(message: "Sorry! There was a problem. (simulated error)")))
                }
            }
        }
    }
}
