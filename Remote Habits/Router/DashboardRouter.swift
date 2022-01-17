import Foundation
import UIKit

protocol DashboardRouting {
    func routeToDashboardDetail(withData: Habits?)
    func routeToSwitchWorkspace(withData: WorkspaceData?)
    func routeToLogin()
    func routeSetToLogin()
}

class DashboardRouter: DashboardRouting {
    weak var dashboardViewController: DashboardViewController?

    func routeToDashboardDetail(withData: Habits?) {
        if let habitData = withData {
            let viewController = HabitDetailViewController.newInstance()
            viewController.habitDetailData = habitData
            let navigation = UINavigationController(rootViewController: viewController)
            dashboardViewController?.present(navigation, animated: true, completion: nil)
        }
    }

    func routeToSwitchWorkspace(withData workspaceData: WorkspaceData?) {
        if let presented = dashboardViewController?.presentedViewController {
            presented.dismiss(animated: false)
        }
        let viewController = SwitchWorkspaceViewController.newInstance()
        viewController.workspaceData = workspaceData
        let navigation = UINavigationController(rootViewController: viewController)
        dashboardViewController?.present(navigation, animated: true, completion: nil)
    }

    func routeToLogin() {
        dashboardViewController?.navigationController?.popToRootViewController(animated: true)
    }

    func routeSetToLogin() {
        dashboardViewController?.navigationController?.setViewControllers([LoginViewController.newInstance()],
                                                                          animated: true)
    }
}
