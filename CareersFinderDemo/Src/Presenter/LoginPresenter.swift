import Foundation
import RxSwift
import FBSDKLoginKit

protocol LoginPresenter {
    init(view: LoginView)
    func login(email: String, password: String)
    func login(with fbInfo: FacebookLoginInfo)
    func loginLI(with info: FacebookLoginInfo)
}

class LoginPresenterImpl : LoginPresenter {

    unowned let view: LoginView
    private let disposeBag = DisposeBag()

    required init(view: LoginView) {
        self.view = view
    }

    func login(email: String, password: String) {
        view.showProgress()
        UserApiManager.shared.login(email: email, password: password)
            .subscribeOn(Dependencies.sharedInstance.backgroundScheduler)
            .observeOn(Dependencies.sharedInstance.mainScheduler)
            .subscribe(
                onSuccess: { wrapper in
                    self.view.hideProgress()
                    if let errModel = wrapper.error {
                        self.view.loginError(error: errModel, info: nil)
                        return
                    }
                    if let model = wrapper.model {
                        self.view.loginSuccess(user: model)
                        return
                    }
            },
                onError: { (error) in
                    self.view.hideProgress()
                    self.view.loginError(error: error)
            }
        ).disposed(by: disposeBag)
    }

    func login(with fbInfo: FacebookLoginInfo) {
        view.showProgress()
        UserApiManager.shared.loginWithFacebook(userId: fbInfo.userId)
            .subscribeOn(Dependencies.sharedInstance.backgroundScheduler)
            .observeOn(Dependencies.sharedInstance.mainScheduler)
            .subscribe(
                onSuccess: { wrapper in
                    self.view.hideProgress()
                    if let errModel = wrapper.error {
                        self.view.loginError(error: errModel, info: fbInfo)
                        LoginManager().logOut()
                        return
                    }
                    if let model = wrapper.model {
                        self.view.loginSuccess(user: model)
                        return
                    }
            },
                onError: { error in
                    self.view.hideProgress()
                    self.view.loginError(error: error)
                    LoginManager().logOut()
            }).disposed(by: disposeBag)
    }

    func loginLI(with info: FacebookLoginInfo) {
        view.showProgress()
        UserApiManager.shared.loginWithLinkedIn(info: info)
            .subscribeOn(Dependencies.sharedInstance.backgroundScheduler)
            .observeOn(Dependencies.sharedInstance.mainScheduler)
            .subscribe(
                onSuccess: { (wrapper) in
                    self.view.hideProgress()
                    if let errModel = wrapper.error {
                        self.view.loginError(error: errModel, info: info)
                        return
                    }
                    if let model = wrapper.model {
                        self.view.loginSuccess(user: model)
                        return
                    }
            },
                onError: { (error) in
                    self.view.hideProgress()
                    self.view.loginError(error: error)
            }).disposed(by: disposeBag)
    }

}
