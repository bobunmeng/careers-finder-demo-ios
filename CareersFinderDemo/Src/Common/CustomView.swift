import UIKit

@IBDesignable
class CustomView: UIView {

    @IBInspectable var cornerRadius: CGFloat = 2

    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
    }

}
