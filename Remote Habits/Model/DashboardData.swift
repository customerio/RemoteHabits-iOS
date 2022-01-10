import Foundation

struct HabitHeadersInfo: Hashable {
    let headerTitle: String?
    let titleFontSize: Int?
    let titleFontName: String?
    let ids: [Int]?
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
    // =======
    // enum HabitElementType {
//    case toggleSwitch
//    case button
    // }
//
    // enum HabitActionType {
//    case logout
//    case login
//    case switchWorkspace
//    case toggleSwitch
    // }
//
    // struct HabitData {
//    let icon: String?
//    let title: String?
//    let subTitle: String?
//    let type: HabitElementType?
//    var habitDetail: HabitDetail?
    // }
//
    // struct HabitDetail {
//    var isHabitEnabled: Bool?
//    var frequency: Int?
//    var startTime: String?
//    var endTime: String?
//    var description: String?
//    var actionButtonValue: String?
//    var actionType: HabitActionType?
    // }
//
    // struct HabitHeadersInfo: Hashable {
//    let headerTitle: String?
//    let titleFontSize: Int?
//    let titleFontName: String?
    // }
//
    // struct SelectedHabitData: Encodable {
//    let title: String?
//    let frequency: Int?
//    let startTime: String?
//    let endTime: String?
    // >>>>>>> main
}
