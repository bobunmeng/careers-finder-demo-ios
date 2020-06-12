import UIKit
import RxCocoa
import RxSwift

class ForgotPasswordResetViewController : BaseViewController {

    @IBOutlet weak var textFieldNewPassword: TextField!
    @IBOutlet weak var labelErrorNewPassword: UILabel!
    @IBOutlet weak var textFieldConfirmPassword: TextField!
    @IBOutlet weak var labelErrorConfirmPassword: UILabel!
    @IBOutlet weak var buttonDone: Button!
    @IBOutlet weak var buttonBack: UIButton!

    private let disposeBag = DisposeBag()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if labelErrorNewPassword == nil {
            return
        }
        labelErrorNewPassword.isHidden = true
        labelErrorNewPassword.text = ""
        labelErrorConfirmPassword.isHidden = true
        labelErrorConfirmPassword.text = ""
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    public func onReset(handler: @escaping ((String) -> Void)) {
        buttonDone.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                let (validated, newPassword) = self.isValidated()
                if !validated {
                    return
                }
                handler(newPassword)
            }).disposed(by: disposeBag)
    }

    public func onBack(action: @escaping (() -> Void)) {
        buttonBack.rx.tap
            .subscribe(onNext: { _ in
                action()
            }).disposed(by: disposeBag)
    }

    private func isValidated() -> (Bool, String) {
        let newPassword = textFieldNewPassword.text ?? ""
        let confirmPassword = textFieldConfirmPassword.text ?? ""

        if newPassword.isEmpty {
            self.setError(error: "Please input new password")
            return (false, "")
        } else {
            labelErrorNewPassword.isHidden = true
        }

        if confirmPassword.isEmpty {
            labelErrorConfirmPassword.text = "Please input confirm password"
            labelErrorConfirmPassword.isHidden = false
            return (false, "")
        } else {
            labelErrorConfirmPassword.isHidden = true
        }

        if newPassword != confirmPassword {
            labelErrorConfirmPassword.text = "Password doesn't match"
            labelErrorConfirmPassword.isHidden = false
            return (false, "")
        } else {
            labelErrorConfirmPassword.isHidden = true
        }

        return (true, newPassword)
    }

    public func setError(error: String) {
        labelErrorNewPassword.text = error
        labelErrorNewPassword.isHidden = false
    }

}
