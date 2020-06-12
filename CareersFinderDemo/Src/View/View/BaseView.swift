import Foundation
import Crashlytics
import UIKit
import MBProgressHUD

protocol BaseView {

    func showProgress()
    func hideProgress()
    func showError(_ error: Error)
    func showError(_ errorModel: ErrorModel)

}


extension BaseView where Self: UIViewController {

    func showProgress() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        var loadingView = MBProgressHUD()
        loadingView = MBProgressHUD.showAdded(to: view, animated: true)
        loadingView.mode = MBProgressHUDMode.indeterminate
        loadingView.label.text = "Loading"
        loadingView.isUserInteractionEnabled = true
    }

    func hideProgress() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        MBProgressHUD.hide(for: view, animated: true)
    }

    func showError(_ error: Error) {
        Alert.shared.display(message: "Unknown Error! Please try again!", on: self)
        Crashlytics.sharedInstance().recordError(error)
    }

    func showError(_ errorModel: ErrorModel) {
        if let code = errorModel.errorCode, code == .noToken {
            Alert.shared.display(
                title: "Login",
                message: "You need to login first",
                onOkClicked: {
                self.present(LoginViewController.newInstance(), animated: true, completion: nil)
            },
                onCancelClicked: {},
                on: self)
        }
        let message = errorModel.message ?? "Unknown error"
        Alert.shared.display(message: message, on: self)
    }

}
