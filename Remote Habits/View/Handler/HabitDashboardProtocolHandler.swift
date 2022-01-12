import Foundation

protocol DashboardActionHandler: AnyObject {
    func logoutUser()
    func loginUser()
    func switchWorkspace()
    func toggleHabit(toValue isEnabled: Bool, habitData: SelectedHabitData)
}

protocol DashboardDetailActionHandler {
    func toggleHabit(toValue isEnabled: Bool)
}

protocol DashboardDetailTimeHandler {
    func updateTime(with: SelectedHabitData)
}
