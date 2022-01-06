import Foundation
import UIKit

struct RHFont {
    static let SFProTextSemiBoldMedium = UIFont(name: "SFProText-Semibold", size: 17)
    static let AwesomeFontLarge = UIFont(name: "FontAwesome", size: 20)
}

enum RHColor {
    static let LabelGray = UIColor(named: "LabelGray") ?? UIColor.gray
    static let LineGray = UIColor(named: "LineGray") ?? UIColor.gray
    static let SelectedLineGray = UIColor(named: "SelectedLineGray") ?? UIColor.gray
    static let DefaultBackground = UIColor(named: "DefaultBackground")
    static let ButtonEnabled = UIColor(named: "ButtonEnabled")
    static let ButtonDisabled = UIColor(named: "ButtonDisabled")
    static let TextDisabled = UIColor(named: "TextDisabled") ?? UIColor.gray
}

// Medium - 17
// Small - 15
// Large - 20
