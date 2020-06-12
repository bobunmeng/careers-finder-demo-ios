import UIKit
import RxCocoa
import RxSwift

class ForgotPasswordStartViewController: BaseViewController {

    @IBOutlet weak var textFieldEmail: TextField!
    @IBOutlet weak var labelErrorEmail: UILabel!
    @IBOutlet weak var buttonContinue: Button!
    @IBOutlet weak var buttonBack: UIButton!

    private let disposeBag = DisposeBag()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if labelErrorEmail == nil {
            return
        }
        labelErrorEmail.isHidden = true
        labelErrorEmail.text = ""
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    public func onContinue(completion: @escaping ((String) -> Void)) {
        buttonContinue.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                guard let email = self.textFieldEmail.text, !email.isEmpty else {
                    self.setError(error: "Please input email")
                    return
                }
                completion(email)
            }).disposed(by: disposeBag)
    }

    public func onBack(action: @escaping (() -> Void)) {
        buttonBack.rx.tap
            .subscribe(onNext: { _ in
                action()
            }).disposed(by: disposeBag)
    }

    public func setError(error: String) {
        labelErrorEmail.isHidden = false
        labelErrorEmail.text = error
    }

}
