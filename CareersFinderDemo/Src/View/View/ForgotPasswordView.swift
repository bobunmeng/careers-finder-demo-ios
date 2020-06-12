import Foundation

protocol ForgotPasswordView: class, BaseView {
    func doneConfirmEmail(error: ErrorModel?)
    func doneConfirmCode(error: ErrorModel?)
    func doneResetPassword(error: ErrorModel?)
}
