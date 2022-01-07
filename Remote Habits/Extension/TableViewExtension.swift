import Foundation
import UIKit

enum TableRowHeight: CGFloat {
    case defaultHeight = 80
    case height100 = 100
}

extension UITableView {
    func setAutomaticRowHeight(height: TableRowHeight) {
        rowHeight = UITableView.automaticDimension
        estimatedRowHeight = height.rawValue
    }
}
