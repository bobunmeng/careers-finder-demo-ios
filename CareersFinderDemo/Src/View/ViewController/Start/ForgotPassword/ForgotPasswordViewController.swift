import UIKit
import RxCocoa
import RxSwift

class ForgotPasswordViewController: UIPageViewController {

    private let firstViewController: ForgotPasswordStartViewController = ForgotPasswordStartViewController.newInstance(storyboardName: "ForgotPassword")
    private let secondViewController: ForgotPasswordConfirmCodeViewController = ForgotPasswordConfirmCodeViewController.newInstance(storyboardName: "ForgotPassword")
    private let thirdViewController: ForgotPasswordResetViewController = ForgotPasswordResetViewController.newInstance(storyboardName: "ForgotPassword")

    private lazy var presenter = { ForgotPasswordPresenterImpl(view: self) }()
    private let disposeBag = DisposeBag()

    private var email: String = ""
    private var code: String = ""
    private var emailErrorModel: Variable<ErrorModel?> = Variable(nil)
    private var codeErrorModel: Variable<ErrorModel?> = Variable(nil)
    private var pwdResetErrorModel: Variable<ErrorModel?> = Variable(nil)

    public static func newInstance() -> ForgotPasswordViewController {
        let storyboard = UIStoryboard(name: "ForgotPassword", bundle: nil)
        return storyboard.instantiateInitialViewController() as! ForgotPasswordViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        firstPage()
    }

    public func back() {
        if let _ = self.presentingViewController as? ForgotPasswordConfirmCodeViewController {
            firstPage(direction: .reverse)
        }
    }

    private func firstPage(direction: UIPageViewControllerNavigationDirection = .forward) {
        setViewControllers([firstViewController], direction: direction, animated: true, completion: nil)
        firstViewController.onContinue { (email) in
            self.presenter.confirmEmail(email: email)
            self.email = email
        }
        firstViewController.onBack {
            self.navigationController?.popViewController(animated: true)
        }
        emailErrorModel
            .asObservable()
            .subscribe(onNext: { [unowned self] errorModel in
                if let err = errorModel {
                    self.firstViewController.setError(error: err.errorMessage)
                }
            }).disposed(by: disposeBag)
    }

    private func secondPage(direction: UIPageViewControllerNavigationDirection = .forward) {
        setViewControllers([secondViewController], direction: direction, animated: true, completion: nil)
        secondViewController.onContinue { (code) in
            self.presenter.confirmCode(email: self.email, code: code)
            self.code = code
        }
        secondViewController.onBack {
            self.firstPage(direction: .reverse)
        }
        codeErrorModel
            .asObservable()
            .subscribe(onNext: { [unowned self] errorModel in
                if let err = errorModel {
                    self.secondViewController.setError(error: err.errorMessage)
                }
            }).disposed(by: disposeBag)
    }

    private func thirdPage(direction: UIPageViewControllerNavigationDirection = .forward) {
        setViewControllers([thirdViewController], direction: direction, animated: true, completion: nil)
        thirdViewController.onReset { (newPassword) in
            self.presenter.resetPassword(email: self.email, code: self.code, password: newPassword)
        }
        thirdViewController.onBack {
            self.secondPage(direction: .reverse)
        }
        pwdResetErrorModel
            .asObservable()
            .subscribe(onNext: { [unowned self] errorModel in
                if let err = errorModel {
                    self.thirdViewController.setError(error: err.errorMessage)
                }
            }).disposed(by: disposeBag)
    }

}

extension ForgotPasswordViewController : ForgotPasswordView {

    func doneConfirmEmail(error: ErrorModel?) {
        error != nil ? emailErrorModel.value = error : secondPage()
    }

    func doneConfirmCode(error: ErrorModel?) {
        error != nil ? codeErrorModel.value = error : thirdPage()
    }

    func doneResetPassword(error: ErrorModel?) {
        if let err = error {
            pwdResetErrorModel.value = err
            return
        }
        Alert.shared.display(message: "Done", onOkClicked: {
            self.navigationController?.popViewController(animated: true)
        }, onCancelClicked: nil, on: self)
    }

}

