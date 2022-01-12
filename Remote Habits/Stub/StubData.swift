import Foundation

class RemoteHabitsData {
    let userManager = DI.shared.userManager
    private var isLoggedIn: Bool {
        userManager.isLoggedIn
    }

    func getHabitHeaders() -> [HabitHeadersInfo] {
        let title = isLoggedIn ? userManager.userName : "Guest"
        let sectionfirst = HabitHeadersInfo(headerTitle: "\(title ?? "Your")'s Habits", titleFontSize: 34,
                                            titleFontName: "SFProDisplay-Bold", rowType: [.hydration, .breaks, .focus])
        let sectionsecond = HabitHeadersInfo(headerTitle: "Details", titleFontSize: 17,
                                             titleFontName: "SFProDisplay-Bold", rowType: [.user, .workspaceInfo])

        return [sectionfirst, sectionsecond]
    }

    func getHabitsData() -> [HabitsData] {
        let habitsHeaderRows = getHabitsHeaderRows()
        let detailHeaderRows = getDetailsHeaderRows()

        return habitsHeaderRows + detailHeaderRows
    }

    func getHabitsHeaderRows() -> [HabitsData] {
        let hydration = HabitsData(id: 1,
                                   icon: "coffee",
                                   title: "Hydration",
                                   subtitle: "Set reminders to drink water",
                                   type: .toggleSwitch,
                                   isEnabled: false,
                                   frequency: 8,
                                   startTime: nil,
                                   endTime: nil,
                                   habitDescription: AppStrings.habitInfoHydrationDescription.localized,
                                   actionName: nil,
                                   actionType: nil)

        let takingBreaks = HabitsData(id: 2,
                                      icon: "timer",
                                      title: "Taking Breaks",
                                      subtitle: "Set reminders to take breaks",
                                      type: .toggleSwitch,
                                      isEnabled: false,
                                      frequency: 5,
                                      startTime: nil,
                                      endTime: nil,
                                      habitDescription: AppStrings.habitInfoBreakDescription.localized,
                                      actionName: nil,
                                      actionType: nil)

        let focusTime = HabitsData(id: 3,
                                   icon: "brain",
                                   title: "Focus Time",
                                   subtitle: "Set reminders to focus",
                                   type: .toggleSwitch,
                                   isEnabled: false,
                                   frequency: 2,
                                   startTime: nil,
                                   endTime: nil,
                                   habitDescription: AppStrings.habitInfoFocusDescription.localized,
                                   actionName: nil,
                                   actionType: nil)

        return [hydration, takingBreaks, focusTime]
    }

    func getDetailsHeaderRows() -> [HabitsData] {
        let userData = getUserData()

        let workspaceData = HabitsData(id: 5,
                                       icon: "ciologo",
                                       title: "Site Id",
                                       subtitle: userManager.workspaceID,
                                       type: .button,
                                       isEnabled: true,
                                       frequency: nil,
                                       startTime: nil,
                                       endTime: nil,
                                       habitDescription: nil,
                                       actionName: "Switch",
                                       actionType: .switchWorkspace)

        let sdkData = HabitsData(id: 6,
                                 icon: "phone",
                                 title: "SDK",
                                 subtitle: Constants.mockSdkInfo,
                                 type: ElementType.none,
                                 isEnabled: nil,
                                 frequency: nil,
                                 startTime: nil,
                                 endTime: nil,
                                 habitDescription: nil,
                                 actionName: nil,
                                 actionType: nil)

        return [userData, workspaceData, sdkData]
    }

    func getUserData() -> HabitsData {
        HabitsData(id: 4,
                   icon: isLoggedIn ? "ciouser" : "guest",
                   title: isLoggedIn ? userManager.userName : "Guest",
                   subtitle: isLoggedIn ? userManager.email : "Anonymous",
                   type: .button,
                   isEnabled: true,
                   frequency: nil,
                   startTime: nil,
                   endTime: nil,
                   habitDescription: nil,
                   actionName: isLoggedIn ? "Log Out" : "Log In",
                   actionType: isLoggedIn ? .logout : .login)
    }
}
