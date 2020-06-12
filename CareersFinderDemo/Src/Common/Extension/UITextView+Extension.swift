import UIKit

extension UITextView {

    open override func awakeFromNib() {
        super.awakeFromNib()

        addDoneButtonOnKeyboard()
    }

    /**
     * addDoneButtonOnKeyboard
     */
    private func addDoneButtonOnKeyboard() {
        if self.isEditable == false {
            return
        }
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

}
