import UIKit

@IBDesignable
class TextField : UITextField {

    @IBInspectable
    public var placeholderColor: UIColor = .white {
        didSet {
            if let placeholder = self.placeholder {
                self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedStringKey.foregroundColor: placeholderColor])
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        self.addDoneButtonOnKeyboard()
        self.tintColor = .white
    }

    /**
     * addDoneButtonOnKeyboard
     */
    private func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneOnKeyboardButton))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        self.inputAccessoryView = doneToolbar
    }

    /**
     * doneOnKeyboardButton
     */
    @objc func doneOnKeyboardButton() {
        self.resignFirstResponder()
    }

    /**
     * onFocus
     * Display hint label
     */
    func onFocus(_ labelHint: UILabel) {
        if labelHint.isHidden == false {
            return
        }
        let height = self.frame.height
        let fontSize = self.font?.pointSize ?? 0
        labelHint.isHidden = false
        UIView.animate(withDuration: 0.5) {
            labelHint.center.x -= 5
            labelHint.center.y -= height / 2 - fontSize / 2
        }
    }

    /**
    * lostFocus
    * Hide hint label
    */
    func lostFocus(_ labelHint: UILabel, _ completion: @escaping () -> Void) {
        if labelHint.isHidden == true {
            return
        }
        let height = self.frame.height
        let fontSize = self.font?.pointSize ?? 0
        if (self.text ?? "").isEmpty {
            UIView.animate(withDuration: 0.5, animations: {
                labelHint.center.x += 5
                labelHint.center.y += height / 2 + fontSize / 2
            }) { (_) in
                completion()
            }
        }
    }

    /**
     * maxText
     * set maximum input text to textfield
     */
    func maxText(max: Int, _ range: NSRange, _ string: String) -> Bool {
        guard let text = self.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= max
    }

}
