import Foundation

protocol RHDashboardActionHandler: AnyObject {
    func logoutUser()
    func loginUser()
    func switchWorkspace()
    func toggleHabit(toValue isEnabled: Bool, habitData: SelectedHabitData)
}

protocol RHDashboardDetailActionHandler {
    func toggleHabit(toValue isEnabled: Bool)
}

protocol RHDashboardDetailTimeHandler {
    func updateTime(with: SelectedHabitData)
}
