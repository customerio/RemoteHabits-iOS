import Foundation

enum AppStrings: String {
    case habitInfoHydrationDescription
    case habitInfoFocusDescription
    case habitInfoBreakDescription

    var localized: String {
        NSLocalizedString(rawValue, comment: "")
    }
}
