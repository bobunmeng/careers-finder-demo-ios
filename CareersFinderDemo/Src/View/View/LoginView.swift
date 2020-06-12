import Foundation

protocol LoginView: class, BaseView {
    func loginSuccess(user: Auth)
    func loginError(error: ErrorModel, info: FacebookLoginInfo?)
    func loginError(error: Error)
}
