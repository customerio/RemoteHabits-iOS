import UIKit
extension UIButton {
    func addColoredBorder(color: UIColor) {
        layer.borderWidth = 0.5
        layer.borderColor = color.cgColor
        setCornerRadius(.radius5)
    }

    func customiseFloating() {
        let xCoordinates = Int(UIScreen.main.bounds.width - 56)
        let widthHeight = 40
        frame = CGRect(x: xCoordinates, y: 50, width: widthHeight, height: widthHeight)
        setImage(UIImage(named: "settings")!, for: .normal)
        self.layer.cornerRadius = CGFloat(widthHeight / 2)

        // Adding light shadow to floating button
        let layer = self.layer
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 2.5, height: 1.5)
        layer.shadowOpacity = 0.7
        layer.masksToBounds = false
        layer.shadowRadius = 1.0
    }
}
