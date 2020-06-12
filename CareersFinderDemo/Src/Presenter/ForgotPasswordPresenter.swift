import Foundation
import RxSwift

protocol ForgotPasswordPresenter {
    func confirmEmail(email: String)
    func confirmCode(email: String, code: String)
    func resetPassword(email: String, code: String, password: String)
}

class ForgotPasswordPresenterImpl : ForgotPasswordPresenter {

    unowned let view: ForgotPasswordView
    private let disposeBag = DisposeBag()

    required init(view: ForgotPasswordView) {
        self.view = view
    }

    func confirmEmail(email: String) {
        view.showProgress()
        UserApiManager.shared.forgotPassword(email: email)
            .subscribeOn(Dependencies.sharedInstance.backgroundScheduler)
            .observeOn(Dependencies.sharedInstance.mainScheduler)
            .subscribe(
                onSuccess: { (wrapper) in
                    self.view.hideProgress()
                    self.view.doneConfirmEmail(error: wrapper.error)
            },
                onError: { (error) in
                    self.view.hideProgress()
                    self.view.showError(error)
            }).disposed(by: disposeBag)
    }

    func confirmCode(email: String, code: String) {
        view.showProgress()
        UserApiManager.shared.forgotPassword(email: email, code: code)
            .subscribeOn(Dependencies.sharedInstance.backgroundScheduler)
            .observeOn(Dependencies.sharedInstance.mainScheduler)
            .subscribe(
                onSuccess: { (wrapper) in
                    self.view.hideProgress()
                    self.view.doneConfirmCode(error: wrapper.error)
            },
                onError: { (error) in
                    self.view.hideProgress()
                    self.view.showError(error)
            }).disposed(by: disposeBag)
    }

    func resetPassword(email: String, code: String, password: String) {
        view.showProgress()
        UserApiManager.shared.forgotPassword(email: email, code: code, newPassword: password, confirmPassword: password)
            .subscribeOn(Dependencies.sharedInstance.backgroundScheduler)
            .observeOn(Dependencies.sharedInstance.mainScheduler)
            .subscribe(
                onSuccess: { (wrapper) in
                    self.view.hideProgress()
                    self.view.doneResetPassword(error: wrapper.error)
            },
                onError: { (error) in
                    self.view.hideProgress()
                    self.view.showError(error)
            }).disposed(by: disposeBag)
    }

}
