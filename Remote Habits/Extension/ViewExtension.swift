import Foundation
import UIKit

enum CornerRadius: CGFloat {
    case radius5  = 5
    case radius13 = 13
    case radius24 = 24
    case radius40 = 40
}

extension UIView {
    func setCornerRadius(_ radius: CornerRadius) {
        layer.cornerRadius = radius.rawValue
    }
}
