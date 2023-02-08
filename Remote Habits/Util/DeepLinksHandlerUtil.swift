import Foundation

protocol DeepLinksHandlerUtil {
    func handleAppSchemeDeepLink(_ url: URL) -> Bool
    func handleUniversalLinkDeepLink(_ url: URL) -> Bool
}

// sourcery: InjectRegister = "DeepLinksHandlerUtil"
class AppDeepLinksHandlerUtil: DeepLinksHandlerUtil {
    private let userManager: UserManager

    init(userManager: UserManager) {
        self.userManager = userManager
    }

    // URLs accepted:
    // remote-habits://switch_workspace?site_id=AAA&api_key=BBB
    func handleAppSchemeDeepLink(_ url: URL) -> Bool {
        switch url.host {
        case "switch_workspace":
            return handleSwitchWorkspaceAction(url: url)
        default: return false
        }
    }

    // URLs accepted:
    // https://remotehabits.page.link/switch_workspace?site_id=AAA&api_key=BBB
    //
    // The domain name used for universal links is https://remotehabits.page.link it is a domain name provided by the
    // Firebase project for Remote Habits. The Firebase Dynamic Links product provides a free domain name and will
    // generate the file required for universal links:
    // https://remotehabits.page.link/.well-known/apple-app-site-association
    // Help with universal links:
    // https://developer.apple.com/documentation/xcode/supporting-universal-links-in-your-app?language=objc
    func handleUniversalLinkDeepLink(_ url: URL) -> Bool {
        switch url.path {
        case "/switch_workspace":
            return handleSwitchWorkspaceAction(url: url)
        default: return false
        }
    }
}

extension AppDeepLinksHandlerUtil {
    // Call this function if you have confirmed the deep link is a switch_workspace deep link. This function assumes you
    // have confirmed that.
    private func handleSwitchWorkspaceAction(url: URL) -> Bool {
        guard let queryParams = NSURLComponents(url: url, resolvingAgainstBaseURL: true)?.queryItems else {
            return false
        }

        guard let siteId = queryParams.first(where: { $0.name == "site_id" })?.value,
              let apiKey = queryParams.first(where: { $0.name == "api_key" })?.value
        else {
            return false
        }

        let userInfo = ["site_id": siteId, "api_key": apiKey]
        let identifier = userManager.isLoggedIn ? Constants.kSwitchWorkspaceNotificationIdentifier : Constants
            .kSwitchWorkspacePreLoginIdentifier
        NotificationCenter.default
            .post(name: Notification.Name(identifier),
                  object: nil, userInfo: userInfo as [AnyHashable: Any])

        return true
    }
}
