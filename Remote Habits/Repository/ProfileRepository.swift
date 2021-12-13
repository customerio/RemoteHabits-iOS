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
    
    func logoutUser()
    
    func validateWorkspace<T: Codable>(forSiteId siteId: String,
                           and apiKey : String,
                           onComplete : @escaping (Result<T, HumanReadableError>) -> Void)
}

// sourcery: InjectRegister = "ProfileRepository"
class AppProfileRepository: ProfileRepository {
    
    func logoutUser() {
        
        self.cio.clearIdentify()
    }
    
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
                    self.userManager.userName = firstName
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
    
//    private func deleteDeviceTokenFromPreviousProfile(_ onComplete: @escaping (Result<Void, CustomerIOError>) -> Void) {
//        guard userManager.apnDeviceToken != nil || userManager.fcmDeviceToken != nil else {
//            return onComplete(.success(()))
//        }
//
//        messagingPush.deleteDeviceToken(onComplete: onComplete)
//    }
//
//    private func registerDeviceTokenNewProfile(_ onComplete: @escaping (Result<Void, CustomerIOError>) -> Void) {
//        if let existingDeviceToken = userManager.apnDeviceToken {
//            return messagingPush.registerDeviceToken(apnDeviceToken: existingDeviceToken, onComplete: onComplete)
//        }
//        if let existingDeviceToken = userManager.fcmDeviceToken {
//            return messagingPush.registerDeviceToken(existingDeviceToken, onComplete: onComplete)
//        }
//
//        return onComplete(.success(()))
//    }
    
    func validateWorkspace<T: Codable>(forSiteId siteId : String, and apiKey : String, onComplete : @escaping(Result<T, HumanReadableError>) -> Void) {
        
        guard let url = URL(string: "https://track.customer.io/dexterity-check") else {
            return onComplete(.failure(self.cioErrorUtil.parse(.notInitialized)))
        }
       
        let headers = getHeaders(forSiteId: siteId, and: apiKey)
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = [
            "Authorization" : "Basic \(headers)"
        ]
        
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data else {
                return onComplete(.failure(self.cioErrorUtil.parse(.notInitialized)))
            }
            do {
                let responseObject = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    // Complete the call with success response & the decoded data
                    onComplete(.success(responseObject))
                    return
                }
            }
            catch (let error) {
                onComplete(.failure(self.cioErrorUtil.parse(.notInitialized)))
            }
            
        }.resume()
    }
    
    private func getHeaders(forSiteId siteId : String, and apiKey : String) -> String {
        let rawHeader = "\(siteId):\(apiKey)"
        let encodedRawHeader = rawHeader.data(using: .utf8)!

        return encodedRawHeader.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
    }
}
