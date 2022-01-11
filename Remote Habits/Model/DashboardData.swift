import Foundation

enum HabitRowType: Int {
    case hydration = 1
    case breaks = 2
    case focus = 3
    case user = 4
    case workspaceInfo = 5
    case sdkInfo = 6
}

struct HabitHeadersInfo: Hashable {
    let headerTitle: String?
    let titleFontSize: Int?
    let titleFontName: String?
    let rowType: [HabitRowType]?
}

struct SelectedHabitData: Encodable {
    let title: String?
    let frequency: Int?
    let startTime: String?
    let endTime: String?
    let id: Int
    let isEnabled: Bool?
}

@objc public enum ActionType: Int32 {
    case logout
    case login
    case switchWorkspace
    case toggleSwitch
    case none
}

@objc public enum ElementType: Int32 {
    case toggleSwitch
    case button
    case none
}

struct HabitsData {
    let id: Int32
    let icon: String?
    let title: String?
    let subtitle: String?
    let type: ElementType?
    let isEnabled: Bool?
    let frequency: Int32?
    let startTime: Date?
    let endTime: Date?
    let habitDescription: String?
    let actionName: String?
    let actionType: ActionType?
}
