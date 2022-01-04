import CioTracking
import Foundation

typealias UserHabit = [[HabitHeadersInfo: [HabitData]]]

class RHStubData {
    var dashboardData: UserHabit = .init()
    let userManager = DI.shared.userManager

    // Disable swiftlint rule until a possible refactor is done in the future. Not critical
    // for this function that just provides stub data.
    // swiftlint:disable:next function_body_length
    func getStubData() -> [[HabitHeadersInfo: [HabitData]]] {
        let isLoggedIn = !(userManager.isGuestLogin ?? true)

        let habitInfoHydration = HabitDetail(isHabitEnabled: false,
                                             frequency: 8,
                                             startTime: "9:00 AM",
                                             endTime: "5:00 PM",
                                             description: AppStrings.habitInfoHydrationDescription.localized,
                                             actionButtonValue: nil, actionType: nil)

        let habitInfoFocus = HabitDetail(isHabitEnabled: false,
                                         frequency: 2,
                                         startTime: "9:00 AM",
                                         endTime: "5:00 PM",
                                         description: AppStrings.habitInfoFocusDescription.localized,
                                         actionButtonValue: nil, actionType: nil)

        let habitInfoBreak = HabitDetail(isHabitEnabled: false,
                                         frequency: 5,
                                         startTime: "9:00 AM",
                                         endTime: "5:00 PM",
                                         description: AppStrings.habitInfoBreakDescription.localized,
                                         actionButtonValue: nil, actionType: nil)

        let habitData = [
            HabitData(icon: "coffee", title: "Hydration", subTitle: "Set reminders to drink water", type: .toggleSwitch,
                      habitDetail: habitInfoHydration),
            HabitData(icon: "timer", title: "Taking Breaks", subTitle: "Set reminders to take breaks",
                      type: .toggleSwitch, habitDetail: habitInfoBreak),
            HabitData(icon: "brain", title: "Focus Time", subTitle: "Set reminders to focus", type: .toggleSwitch,
                      habitDetail: habitInfoFocus)
        ]

        let habitInfo1 = HabitDetail(isHabitEnabled: true, frequency: nil, startTime: nil, endTime: nil,
                                     description: nil, actionButtonValue: "Log out", actionType: .logout)
        let habitInfo2 = HabitDetail(isHabitEnabled: true, frequency: nil, startTime: nil, endTime: nil,
                                     description: nil, actionButtonValue: "Switch", actionType: .switchWorkspace)
        let anonymousHabitInfo = HabitDetail(isHabitEnabled: true, frequency: nil, startTime: nil, endTime: nil,
                                             description: nil, actionButtonValue: "Log In", actionType: .login)
        let anonymousUser = HabitData(icon: "guest", title: "Guest", subTitle: "Anonymous", type: .button,
                                      habitDetail: anonymousHabitInfo)
        let cioUser = HabitData(icon: "ciouser", title: userManager.userName, subTitle: userManager.email,
                                type: .button, habitDetail: habitInfo1)

        let habitDetail = [isLoggedIn ? cioUser : anonymousUser,
                           HabitData(icon: "ciologo", title: "Site Id", subTitle: userManager.workspaceID,
                                     type: .button, habitDetail: habitInfo2),
                           HabitData(icon: "phone",
                                     title: "SDK",
                                     subTitle: RHConstants.mockSdkInfo,
                                     type: nil, habitDetail: nil)]

        // Sections
        let title = isLoggedIn ? userManager.userName : "Guest"
        let section1 = HabitHeadersInfo(headerTitle: "\(title ?? "Your")'s Habits", titleFontSize: 34,
                                        titleFontName: "SFProDisplay-Bold")
        let section2 = HabitHeadersInfo(headerTitle: "Details", titleFontSize: 17, titleFontName: "SFProDisplay-Bold")
        dashboardData.append([section1: habitData])
        dashboardData.append([section2: habitDetail])
        return dashboardData
    }
}
