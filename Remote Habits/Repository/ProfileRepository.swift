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
    private let cioErrorUtil: CustomerIOErrorUtil

    init(cio: CustomerIO, cioErrorUtil: CustomerIOErrorUtil) {
        self.cio = cio
        self.cioErrorUtil = cioErrorUtil
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
                /// identify() calls callback on main thread.
                self.cio.identify(identifier: email, body: ["first_name": firstName]) { [weak self] result in
                    guard let self = self else { return }

                    switch result {
                    case .success:
                        return onComplete(.success(()))
                    case .failure(let cioError):
                        return onComplete(.failure(self.cioErrorUtil.parse(cioError)))
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
}
