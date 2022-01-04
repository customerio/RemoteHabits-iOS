import Foundation
import UIKit

extension UITextField {
    var trimTextWithWhiteSpaces: Bool {
        text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) ?? "" == ""
    }
}
