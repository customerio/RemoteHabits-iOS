import Foundation
import UIKit

protocol LoginRouting {
    func routeToDashboard()
    func routeToWorkspace(withData: WorkspaceData?)
    func routeToConfigureCioSdk()
}

class LoginRouter: LoginRouting {
    weak var loginViewController: LoginViewController?

    func routeToDashboard() {
        let viewController = DashboardViewController.newInstance()
        viewController.isSourceLogin = true
        loginViewController?.navigationController?.pushViewController(viewController, animated: true)
    }

    func routeToWorkspace(withData workspaceData: WorkspaceData?) {
        let viewController = SwitchWorkspaceViewController.newInstance()
        viewController.workspaceData = workspaceData
        let navigation = UINavigationController(rootViewController: viewController)
        loginViewController?.present(navigation, animated: true, completion: nil)
    }

    func routeToConfigureCioSdk() {
        let viewController = ConfigureCioSdkViewController.newInstance()
        let navigation = UINavigationController(rootViewController: viewController)
        loginViewController?.present(navigation, animated: true, completion: nil)
    }
}
