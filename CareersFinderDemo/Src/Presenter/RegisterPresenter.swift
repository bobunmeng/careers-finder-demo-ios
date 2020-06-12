import Foundation
import RxSwift

protocol RegisterPresenter: CareerInfoPresenter {

    init(view: RegisterView)
    func getCategories()
    func registerUser(registrationInfo: RegistrationInfo)
    func registerFacebookUser(fbInfo: FacebookLoginInfo)

}

class RegisterPresenterImpl: RegisterPresenter {

    unowned let view: RegisterView
    private let disposeBag = DisposeBag()

    required init(view: RegisterView) {
        self.view = view
        self.getCategories()
    }

    func getCategories() {
        self.getCategories(
            onSuccess: { [weak self] (categories) in
                self?.view.show(categories: categories)
        },
            onError: { [weak self] (error) in
                self?.view.showError(error)
        }).disposed(by: disposeBag)
    }

    func registerUser(registrationInfo: RegistrationInfo) {
        view.showProgress()
        UserApiManager.shared.register(registrationInfo: registrationInfo)
            .subscribeOn(Dependencies.sharedInstance.backgroundScheduler)
            .observeOn(Dependencies.sharedInstance.mainScheduler)
            .subscribe(
                onSuccess: { [weak self] wrapper in
                    self?.view.hideProgress()
                    if let errModel = wrapper.error {
                        self?.view.showError(errModel)
                        return
                    }
                    self?.view.registerSuccess()
            },
                onError: { [weak self] (error) in
                    self?.view.hideProgress()
                    self?.view.showError(error)
            }).disposed(by: disposeBag)
    }
    
    func registerFacebookUser(fbInfo: FacebookLoginInfo) {
        view.showProgress()
        UserApiManager.shared.register(fbInfo: fbInfo)
            .subscribeOn(Dependencies.sharedInstance.backgroundScheduler)
            .observeOn(Dependencies.sharedInstance.mainScheduler)
            .subscribe(
                onSuccess: { [weak self] wrapper in
                    self?.view.hideProgress()
                    if let errModel = wrapper.error {
                        self?.view.showError(errModel)
                        return
                    }
                    self?.view.registerSuccess()
                },
                onError: { [weak self] (error) in
                    self?.view.hideProgress()
                    self?.view.showError(error)
            }).disposed(by: disposeBag)
    }

}
