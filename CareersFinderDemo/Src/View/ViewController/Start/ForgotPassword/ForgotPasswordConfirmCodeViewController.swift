import UIKit
import RxCocoa
import RxSwift

class ForgotPasswordConfirmCodeViewController: BaseViewController {

    @IBOutlet weak var textFieldConfirmCode: TextField!
    @IBOutlet weak var labelErrorConfirmCode: UILabel!
    @IBOutlet weak var buttonContinue: Button!
    @IBOutlet weak var buttonBack: UIButton!

    private let disposeBag = DisposeBag()
    private let MAX_CONFIRM_CODE_LENGTH = 6

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if labelErrorConfirmCode == nil {
            return
        }
        labelErrorConfirmCode.isHidden = true
        labelErrorConfirmCode.text = ""
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldConfirmCode.delegate = self
    }

    public func onContinue(handler: @escaping ((String) -> Void)) {
        buttonContinue.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                guard let code = self.textFieldConfirmCode.text, !code.isEmpty else {
                    self.setError(error: "Please input code")
                    return
                }
                handler(code)
            }).disposed(by: disposeBag)
    }

    public func onBack(action: @escaping (() -> Void)) {
        buttonBack.rx.tap
            .subscribe(onNext: { _ in
                action()
            }).disposed(by: disposeBag)
    }

    public func setError(error: String) {
        labelErrorConfirmCode.isHidden = false
        labelErrorConfirmCode.text = error
    }

}

extension ForgotPasswordConfirmCodeViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let count = text.count + string.count - range.length
        return count <= MAX_CONFIRM_CODE_LENGTH
    }
    
}
