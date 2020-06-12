import UIKit

class BaseViewController: UIViewController {

    var _constraintBottom: NSLayoutConstraint? = nil {
        didSet {
            if let _ = _constraintBottom {
                NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
            }
        }
    }

    private static func instantiateWithStoryboard<T>() -> T {
        let type = Mirror(reflecting: self).subjectType
        let storyboardName = String(describing: type).components(separatedBy: ".")[0]
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let viewController = storyboard.instantiateInitialViewController() as! T
        if let v = viewController as? UIViewController {
            v.modalPresentationStyle = .fullScreen
        }
        if let v = viewController as? UINavigationController {
            v.modalPresentationStyle = .fullScreen
        }
        return viewController
    }

    private static func instantiateWithStoryboard<T>(_ storyboardName: String) -> T {
        let type = Mirror(reflecting: self).subjectType
        let identifierName = String(describing: type).components(separatedBy: ".")[0]
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: identifierName) as! T
        if let v = vc as? UIViewController {
            v.modalPresentationStyle = .fullScreen
        }
        if let v = vc as? UINavigationController {
            v.modalPresentationStyle = .fullScreen
        }
        return vc
    }

    static func newInstance<T>() -> T {
        return instantiateWithStoryboard()
    }

    static func newInstance<T>(storyboardName: String) -> T {
        return instantiateWithStoryboard(storyboardName)
    }

    static func newInstance<T>(storyboardName: StoryboardIdentifier) -> T {
        return instantiateWithStoryboard(storyboardName.rawValue)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let changeInHeight = (keyboardSize.height + 50)
            DispatchQueue.main.async {
                self._constraintBottom!.constant = changeInHeight
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, animations: {
                self._constraintBottom!.constant = 45
            })
        }
    }

    func sideMenu(menuButton: UIBarButtonItem) {
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 275
            revealViewController().rearViewRevealOverdraw = 0

            view.addGestureRecognizer(revealViewController().panGestureRecognizer())
            view.addGestureRecognizer(revealViewController().tapGestureRecognizer())
        }
    }

    func performSegue(withSegueType segueType: SegueType, sender: Any?) {
        super.performSegue(withIdentifier: segueType.value(), sender: sender)
    }

}
