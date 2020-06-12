import Foundation

protocol RegisterView: class, BaseView {
    func registerSuccess()
    func registerFail()
    func show(categories: [Category])
}
