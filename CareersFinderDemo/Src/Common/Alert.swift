import UIKit

class Alert {

    static let shared = Alert()
    private init() {}

    func display(message: String, okTitle: String? = "OK", on vc: UIViewController) {
        self.display(message: message, okTitle: okTitle, onOkClicked: nil, onCancelClicked: nil, on: vc)
    }

    func display(title: String? = nil, message: String, okTitle: String? = "OK", onOkClicked: (() -> Void)?, onCancelClicked: (() -> Void)?, on vc: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: okTitle, style: .default, handler: { (action) in
            if let actionClick = onOkClicked {
                actionClick()
            } else {
                alert.dismiss(animated: true, completion: nil)
            }
        }))
        if let _ = onCancelClicked {
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
        }
        vc.present(alert, animated: true, completion: nil)
    }
    
    func display(title: String? = nil, message: String, okTitle: String, onOkClicked: (() -> Void)?, cancelTitle: String? = "Cancel", onCancelClicked: (() -> Void)?, on vc: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: okTitle, style: .default, handler: { (action) in
            if let actionClick = onOkClicked {
                actionClick()
            } else {
                alert.dismiss(animated: true, completion: nil)
            }
        }))
        if let _ = onCancelClicked {
            alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
        }
        vc.present(alert, animated: true, completion: nil)
    }
    
    func showToastMessage(_ msg: String, on controller: UIViewController) {
        let toastLabel = UILabel(frame: CGRect(x: controller.view.frame.width / 2 - 100, y: controller.view.frame.height - 60, width: 200, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = .white
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont(name: toastLabel.font.fontName, size: 12.0)
        toastLabel.text = msg
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10.0
        toastLabel.clipsToBounds = true
        controller.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: [.curveEaseOut], animations: {
            toastLabel.alpha = 0.0
        }, completion: { (_) in
            toastLabel.removeFromSuperview()
        })
    }

}
