import UIKit
import FBSDKLoginKit
import FBSDKLoginKit
import OneSignal

class LoginViewController: BaseViewController {

    @IBOutlet weak var textFieldEmail: TextField!
    @IBOutlet weak var textFieldPassword: TextField!
    @IBOutlet var constraintBottom: NSLayoutConstraint!

    @IBOutlet weak var labelEmailErrMessage: UILabel!
    @IBOutlet weak var labelPasswordErrMessage: UILabel!
    
    private lazy var presenter: LoginPresenter = { LoginPresenterImpl(view: self) }()
    private var transitionType: TransitionType? = nil

    override func viewWillLayoutSubviews() {
        self.navigationController?.isNavigationBarHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self._constraintBottom = self.constraintBottom
        OneSignal.deleteTag(OneSignalTag.userId.rawValue)
        UserDefaultsHelper.remove(key: .skipLogin)
    }

    // - MARK: Action

    @IBAction func login(_ sender: Any) {
        if let email = self.textFieldEmail.text,
            let password = self.textFieldPassword.text,
            self.validated(email, password)
        {
            self.transitionType = .normal
            self.presenter.login(email: email, password: password)
        }
    }

    @IBAction func forgotPassword(_ sender: Any) {
        self.navigationController?.pushViewController(ForgotPasswordViewController.newInstance(), animated: true)
    }

    @IBAction func loginByFacebook(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile", "email"], from: self) { (result, error) in
            if error != nil {
                self.showError(error!)
                return
            }
            if let res = result {
                if res.isCancelled {
                    self.showError(ErrorModel(message: "Facebook Cancelled"))
                    return
                }
                guard let fbToken = res.token else {
                    self.showError(ErrorModel(message: "Unknown Error. Please try again!"))
                    return
                }
                GraphRequest(graphPath: "me", parameters: ["fields": "id, first_name, last_name, email"]).start(completionHandler: { (connection, result, error) in
                    if error == nil {
                        guard let fbDetails = result as? NSDictionary else {
                            self.showError(ErrorModel(message: "Unknown Error! Please try again."))
                            return
                        }
                        let fbDetail = SocialDetail(fbDetail: fbDetails)
                        
                        if fbDetail.id.isEmpty {
                            self.showError(ErrorModel(message: "Unknown Error! Please try again."))
                            return
                        }
                        
                        let fbInfo = FacebookLoginInfo(
                            userId: fbDetail.id,
                            accessToken: fbToken.tokenString,
                            email: fbDetail.email,
                            firstName: fbDetail.firstName,
                            lastName: fbDetail.lastName,
                            imageUrl: fbDetail.imageUrl,
                            profileUrl: fbDetail.imageUrl,
                            contactNumber: "",
                            categoryId: 0,
                            promoCode: "")
                        self.transitionType = .social
                        self.presenter.login(with: fbInfo)
                    }
                })
            }
        }
    }
    
    @IBAction func registerNewAccountTapped(_ sender: Any) {
        self.present(RegisterViewController.newInstance(), animated: true, completion: nil)
    }

    @IBAction func skipLoginTapped(_ sender: Any) {
        UserDefaultsHelper.save(key: .skipLogin, value: UserDefaultsStaticValue.skipLogin.rawValue)
        self.present(SideMenuViewController.newInstance(), animated: true)
    }

    private func validated(_ email: String, _ password: String) -> Bool {

        if email.isEmpty {
            labelEmailErrMessage.text = "Please input email"
            labelEmailErrMessage.isHidden = false
        } else {
            labelEmailErrMessage.isHidden = true
        }

        if password.isEmpty {
            labelPasswordErrMessage.text = "Please input password"
            labelPasswordErrMessage.isHidden = false
        } else {
            labelPasswordErrMessage.isHidden = true
        }

        if !email.isEmpty {
            if !isEmailValid(email: email) {
                labelEmailErrMessage.text = "Email is invalid"
                labelEmailErrMessage.isHidden = false
            } else {
                labelEmailErrMessage.isHidden = true
            }
        }

        return !email.isEmpty && !password.isEmpty && isEmailValid(email: email)
    }
    
}

extension LoginViewController: LoginView {

    func loginSuccess(user: Auth) {
        OneSignal.sendTag(OneSignalTag.userId.rawValue, value: "\(user.id)")
        if self.transitionType == .social {
            UserDefaultsHelper.save(key: .loginWithSocial, value: UserDefaultsStaticValue.loginWithSocial.rawValue)
        }
        Alert.shared.display(message: "Logging in...", on: self)
    }

    func loginError(error: ErrorModel, info: FacebookLoginInfo?) {
        if let httpCode = error.httpCode, httpCode == 404 {
            let registerVC: RegisterFacebookViewController = RegisterFacebookViewController.newInstance()
            registerVC.fbInfo = info
            self.present(registerVC, animated: true, completion: nil)
            return
        }
        self.showError(error)
    }

    func loginError(error: Error) {
        Alert.shared.display(message: "Error \(error.localizedDescription)", on: self)
    }

}

private struct SocialDetail {

    public let id: String
    public let firstName: String
    public let lastName: String
    public let email: String
    public let imageUrl: String
    public let profileUrl: String

    public init(fbDetail: NSDictionary) {
        self.id = fbDetail["id"] as? String ?? ""
        self.email = fbDetail["email"] as? String ?? ""
        self.firstName = fbDetail["first_name"] as? String ?? ""
        self.lastName = fbDetail["last_name"] as? String ?? ""
        self.imageUrl = "https://graph.facebook.com/\(self.id)/picture?type=large&return_ssl_resources=1"
        self.profileUrl = ""
    }

    public init(linkedInDetail: NSDictionary) {
        self.id =  linkedInDetail["id"] as! String
        self.email = linkedInDetail["emailAddress"] as! String
        self.firstName = linkedInDetail["firstName"] as! String
        self.lastName = linkedInDetail["lastName"] as! String
        self.imageUrl = linkedInDetail["pictureUrl"] as! String
        self.profileUrl = linkedInDetail["publicProfileUrl"] as! String
    }

}
