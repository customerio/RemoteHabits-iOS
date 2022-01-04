import Foundation
import UIKit

class RHCustomisedTableView: UITableView {
    override var adjustedContentInset: UIEdgeInsets {
        if frame.height > contentSize.height {
            let heightBottom =
                (frame.height - contentSize.height) + 0.5
            return UIEdgeInsets(top: contentInset.top + 0.5,
                                left: contentInset.left,
                                bottom: heightBottom,
                                right: contentInset.right)
        }
        return UIEdgeInsets(top: contentInset.top + 0.5,
                            left: contentInset.left,
                            bottom: contentInset.right,
                            right: contentInset.right)
    }
}
