import Foundation
import UIKit

extension UIView {
   
    func setCornerRadius() {
        self.layer.cornerRadius = 13
    }
    
    func customiseView() {
        setCornerRadius()
        self.backgroundColor = RHColor.WhiteBackground
    }
}
