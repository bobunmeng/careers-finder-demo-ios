import UIKit

@IBDesignable
class Button : UIButton {

    @IBInspectable
    public var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }

    @IBInspectable
    public var underlineHeight: Int = 0 {
        didSet {
            self.setAttributeTitle()
        }
    }

    @IBInspectable
    public var underlineColor: UIColor = .white {
        didSet {
            self.setAttributeTitle()
        }
    }

    /*
     * setAttributeTitle
     * add all necessary attributes to button
     */

    private func setAttributeTitle() {
        if let title = self.currentTitle {
            let foreColor = self.titleColor(for: self.state) ?? .black
            
            let paragraph = NSMutableParagraphStyle()
            paragraph.alignment = .center
            
            let attributes: [NSAttributedStringKey: Any] =
                [.underlineStyle: underlineHeight,
                 .underlineColor: underlineColor,
                 .foregroundColor: foreColor,
                 .paragraphStyle: paragraph]
            let titleAttrStr = NSMutableAttributedString(string: title, attributes: attributes)
            self.setAttributedTitle(titleAttrStr, for: self.state)
            self.titleLabel?.textAlignment = .center
        }
    }

}
