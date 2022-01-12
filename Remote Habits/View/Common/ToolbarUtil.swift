import Foundation
import UIKit

enum ToolBarButtonItem: String {
    case done = "Done"
}

class Toolbar: UIToolbar {
    // Standard tool bar with height 35
    func standardToolBar(_ withItems: [ToolBarButtonItem: Selector]) -> UIToolbar {
        let toolbar: UIToolbar =
            .init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: Constants.kToolBarHeight))
        toolbar.barStyle = .default
        toolbar.sizeToFit()
        var barButtonItems = [UIBarButtonItem]()
        for buttonItem in withItems {
            let item = UIBarButtonItem(title: buttonItem.key.rawValue, style: .plain, target: self,
                                       action: buttonItem.value)
            barButtonItems.append(item)
        }
        toolbar.items = barButtonItems
        return toolbar
    }
}
