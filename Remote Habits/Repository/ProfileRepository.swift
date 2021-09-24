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

            if diceRoll < 90 {
                self.deleteDeviceTokenFromPreviousProfile { [weak self] result in
                    guard let self = self else { return }

                    if case .failure(let cioError) = result {
                        return onComplete(.failure(self.cioErrorUtil.parse(cioError)))
                    }

                    /// identify() calls callback on main thread.
                    self.cio.identify(identifier: email, body: ["first_name": firstName]) { [weak self] result in
                        guard let self = self else { return }

                        if case .failure(let cioError) = result {
                            return onComplete(.failure(self.cioErrorUtil.parse(cioError)))
                        }

                        /// At this time, the Customer.io SDK does not register a device token to a newly identified
                        /// profile. You must do this manually yourself. So, we register a device token to this
                        /// new profile if a token has been assigned to this device.
                        self.registerDeviceTokenNewProfile { result in
                            switch result {
                            case .success:
                                /// Finally, the profile has been identified. This is the final success case.
                                self.userManager.email = email

                                return onComplete(.success(()))
                            case .failure(let cioError):
                                return onComplete(.failure(self.cioErrorUtil.parse(cioError)))
                            }
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    // As an error, for demo purposes let's always make it that you don't have Internet connection.
                    onComplete(.failure(HumanReadableError(message: "Sorry! There was a problem. (simulated error)")))
                }
            }
        }
    }

    private func deleteDeviceTokenFromPreviousProfile(_ onComplete: @escaping (Result<Void, CustomerIOError>) -> Void) {
        guard userManager.apnDeviceToken != nil || userManager.fcmDeviceToken != nil else {
            return onComplete(.success(()))
        }

        messagingPush.deleteDeviceToken(onComplete: onComplete)
    }

    private func registerDeviceTokenNewProfile(_ onComplete: @escaping (Result<Void, CustomerIOError>) -> Void) {
        if let existingDeviceToken = userManager.apnDeviceToken {
            return messagingPush.registerDeviceToken(apnDeviceToken: existingDeviceToken, onComplete: onComplete)
        }
        if let existingDeviceToken = userManager.fcmDeviceToken {
            return messagingPush.registerDeviceToken(existingDeviceToken, onComplete: onComplete)
        }

        return onComplete(.success(()))
    }
}
