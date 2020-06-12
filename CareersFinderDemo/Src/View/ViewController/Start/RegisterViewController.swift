import UIKit
import DropDown

class RegisterViewController: BaseViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var labelHintFirstName: UILabel!
    @IBOutlet weak var textFieldFirstName: TextField!

    @IBOutlet weak var labelHintLastName: UILabel!
    @IBOutlet weak var textFieldLastName: TextField!

    @IBOutlet weak var labelHintContactNumber: UILabel!
    @IBOutlet weak var textFieldContactNumber: TextField!

    @IBOutlet weak var labelHintEmail: UILabel!
    @IBOutlet weak var textFieldEmail: TextField!

    @IBOutlet weak var labelHintCategory: UILabel!
    @IBOutlet weak var labelCategory: UILabel!

    @IBOutlet weak var labelHintPassword: UILabel!
    @IBOutlet weak var textFieldPassword: TextField!

    @IBOutlet weak var viewLinePassword: UIView!
    @IBOutlet weak var stackViewPassword: UIStackView!
    @IBOutlet weak var labelErrorFirstName: UILabel!
    @IBOutlet weak var labelErrorLastName: UILabel!
    @IBOutlet weak var labelErrorContact: UILabel!
    @IBOutlet weak var labelErrorEmail: UILabel!
    @IBOutlet weak var labelErrorPassword: UILabel!
    @IBOutlet weak var labelErrorCategory: UILabel!
    @IBOutlet weak var labelHintPromoCode: UILabel!
    @IBOutlet weak var textFieldPromoCode: TextField!
    @IBOutlet weak var labelErrorPromoCode: UILabel!
    
    var categories: [Category] = []
    private var activeField: UITextField? = nil
    private var lastOffset: CGPoint = CGPoint(x: 0, y: 0)
    private var keyboardHeight: CGFloat = 0
    private var presenter: RegisterPresenter!
    private lazy var dropDown: DropDown = {
        let dropDown = DropDown()
        dropDown.anchorView = labelCategory
        dropDown.dataSource = categories.map { $0.category }
        dropDown.selectionAction = { [unowned self] (index, item) in
            self.labelCategory.text = item
            dropDown.hide()
        }
        return dropDown
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter = RegisterPresenterImpl(view: self)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)

        let categoryTap = UITapGestureRecognizer(target: self, action: #selector(categoryTapped))
        labelCategory.isUserInteractionEnabled = true
        labelCategory.addGestureRecognizer(categoryTap)
        labelCategory.text = "Please choose a category"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func keyboardWillShow(notification: NSNotification) {
        adjustingHeight(true, notification: notification)
    }

    override func keyboardWillHide(notification: NSNotification) {
        adjustingHeight(false, notification: notification)
    }
    
    private func adjustingHeight(_ show: Bool, notification: NSNotification) {
        if show && keyboardHeight != 0 {
            return
        }
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let changeInHeight = (keyboardSize.height + self.bottomConstraint.constant + 25) * (show ? 1 : -1)
            keyboardHeight = show ? changeInHeight : -keyboardHeight
            scrollView.contentInset.bottom += keyboardHeight
            scrollView.scrollIndicatorInsets.bottom += keyboardHeight
            if !show {
                keyboardHeight = 0
            }
        }
    }

    @objc private func categoryTapped() {
        self.dropDown.show()
    }

    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func registerTapped(_ sender: Any) {
        let selectedCat = dropDown.indexForSelectedRow != nil ? categories[dropDown.indexForSelectedRow!].id : -1
        let registrationInfo = RegistrationInfo(
            firstName: textFieldFirstName.text ?? "",
            lastName: textFieldLastName.text ?? "",
            contactNumber: textFieldContactNumber.text ?? "",
            email: textFieldEmail.text ?? "",
            category: selectedCat,
            password: textFieldPassword.text ?? "",
            promoCode: textFieldPromoCode.text ?? "")
        if !isValid(registrationInfo) {
            return
        }
        self.presenter.registerUser(registrationInfo: registrationInfo)
    }

    private func isValid(_ info: RegistrationInfo) -> Bool {
        var isValidated = true

        if info.firstName.isEmpty {
            showError(label: labelErrorFirstName, fieldRequired: "first name")
            isValidated = false
        } else {
            showError(label: labelErrorFirstName, show: false)
        }

        if info.lastName.isEmpty {
            showError(label: labelErrorLastName, fieldRequired: "last name")
            isValidated = false
        } else {
            showError(label: labelErrorLastName, show: false)
        }
        
        if info.category == -1 {
            labelErrorCategory.text = "Please select category"
            labelErrorCategory.isHidden = false
            isValidated = false
        } else {
            labelErrorCategory.isHidden = true
        }

        if info.contactNumber.isEmpty {
            showError(label: labelErrorContact, fieldRequired: "contact number")
            isValidated = false
        } else {
            if !isValidPhone(number: info.contactNumber) {
                labelErrorContact.text = "Contact number is invalid"
                labelErrorContact.isHidden = false
                isValidated = false
            } else {
                showError(label: labelErrorContact, show: false)
            }
        }

        if info.email.isEmpty {
            showError(label: labelErrorEmail, fieldRequired: "email")
            isValidated = false
        } else {
            if !isEmailValid(email: info.email) {
                labelErrorEmail.text = "Email is invalid"
                labelErrorEmail.isHidden = false
                isValidated = false
            } else {
                showError(label: labelErrorEmail, show: false)
            }
        }

        if info.password.isEmpty {
            showError(label: labelErrorPassword, fieldRequired: "password")
            isValidated = false
        } else {
            showError(label: labelErrorPassword, show: false)
        }

        return isValidated
    }

    private func showError(label: UILabel, fieldRequired: String = "", show: Bool = true) {
        label.text = "Please input \(fieldRequired)"
        label.isHidden = !show
    }

}

// - MARK: View Extension

extension RegisterViewController : RegisterView {

    func registerSuccess() {
        UIApplication.shared.keyWindow?.rootViewController = SideMenuViewController.newInstance(TransitionType.signup)
    }

    func registerFail() {

    }

    func show(categories: [Category]) {
        self.categories = categories
    }

    func showError(_ error: Error) {
        Alert.shared.display(message: error.localizedDescription, on: self)
    }
}

// - MARK: UITextFieldDelegate Extension

extension RegisterViewController : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeField = textField
        lastOffset = self.scrollView.contentOffset
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        activeField?.resignFirstResponder()
        activeField = nil
        self.view.endEditing(true)
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {

        let allTextFields = [
            [textFieldFirstName, labelHintFirstName],
            [textFieldLastName, labelHintLastName],
            [textFieldContactNumber, labelHintContactNumber],
            [textFieldEmail, labelHintEmail],
            [textFieldPassword, labelHintPassword],
            [textFieldPromoCode, labelHintPromoCode]
        ]
        allTextFields.forEach {
            if textField == ($0[0] as! TextField) {
                let tf = $0[0] as! TextField
                let lbl = $0[1] as! UILabel
                tf.onFocus(lbl)
                tf.placeholder = ""
                return
            }
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        let allTextFields = [
            [textFieldFirstName, labelHintFirstName],
            [textFieldLastName, labelHintLastName],
            [textFieldContactNumber, labelHintContactNumber],
            [textFieldEmail, labelHintEmail],
            [textFieldPassword, labelHintPassword],
            [textFieldPromoCode, labelHintPromoCode]
        ]
        allTextFields.forEach {
            if textField == ($0[0] as! TextField) {
                let tf = $0[0] as! TextField
                let lbl = $0[1] as! UILabel
                tf.lostFocus(lbl, {
                    lbl.isHidden = true
                    tf.placeholder = lbl.text
                    tf.placeholderColor = .white
                })
                return
            }
        }
    }

}
