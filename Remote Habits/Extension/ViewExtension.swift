import Foundation
import UIKit

enum CornerRadius : CGFloat {
    case radius13 = 13
    case radius24 = 24
    case radius40 = 40
}

extension UIView {
   
    func setCornerRadius(_ radius : CornerRadius) {
        self.layer.cornerRadius = radius.rawValue
    }
    
    func customiseView() {
        setCornerRadius(.radius13)
        self.backgroundColor = RHColor.WhiteBackground
    }
}
