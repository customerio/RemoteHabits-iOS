import Foundation
import UIKit

protocol SwitchWorkspaceRouting {
    func routeToLogin()
}

class SwitchWorkspaceRouter: SwitchWorkspaceRouting {
    weak var switchWorkspaceViewController: SwitchWorkspaceViewController?

    func routeToLogin() {
        if let navController = switchWorkspaceViewController?.parent as? UINavigationController,
           let presenter = navController.presentingViewController as? UINavigationController {
            presenter.setViewControllers([LoginViewController.newInstance()], animated: true)
            switchWorkspaceViewController?.dismiss(animated: true, completion: nil)
        }
    }
}
