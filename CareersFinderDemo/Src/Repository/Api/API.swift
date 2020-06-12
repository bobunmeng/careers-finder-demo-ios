import Foundation
import Alamofire

enum Api: URLRequestConvertible {

    case login(username: String, password: String)
    case fbLogin(userId: String)
    case register(registrationInfo: RegistrationInfo)
    case registerFb(fbInfo: FacebookLoginInfo)
    case categories
    case forgotPasswordStep1(email: String)
    case forgotPasswordStep2(email: String, code: String)
    case forgotPasswordStep3(email: String, code: String, newPassword: String, confirmPassword: String)
    
    static let baseURLString = "some_url"

    func asURLRequest() throws -> URLRequest {

        let method = self.method()
        let encoding = self.encoding(method)
        let params = self.parameters()
        let url = self.url()
        let urlRequest = self.urlRequest(url, method: method)

        return try encoding.encode(urlRequest, with: params)

    }

    private func method() -> HTTPMethod {
        switch self {
        case .login, .fbLogin, .register, .registerFb, .forgotPasswordStep1, .forgotPasswordStep2, .forgotPasswordStep3:
            return .post
        case .categories:
            return .get
        }
    }

    private func urlRequest(_ url: URL, method: HTTPMethod) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.timeoutInterval = 15
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        return urlRequest
    }

    private func url() -> URL {
        let relativePath: String?
        switch self {
        case .login:
            relativePath = "api/user/v1/login"
        case .fbLogin:
            relativePath = "api/user/v1/facebook"
        case .register:
            relativePath = "api/user/v1/register"
        case .registerFb:
            relativePath = "api/user/v1/register-facebook"
        case .categories:
            relativePath = "api/category/v1/list"
        case .forgotPasswordStep1:
            relativePath = "api/auth/v1/forgot-password"
        case .forgotPasswordStep2:
            relativePath = "api/auth/v1/confirm-code"
        case .forgotPasswordStep3:
            relativePath = "api/auth/v1/reset-password"
        }

        var url = URL(string: Api.baseURLString)!
        if let relativePath = relativePath {
            url = url.appendingPathComponent(relativePath)
        }
        return url
    }

    private func parameters() -> [String: Any]? {
        switch self {
        case .login(let username, let password):
            return [
                "username": username,
                "password": password
            ]
        case .fbLogin(let userId):
            return [
                "userId": userId
            ]
        case .register(let info):
            return [
                "username": info.email,
                "password": info.password,
                "firstName": info.firstName,
                "lastName": info.lastName,
                "contactNumber": info.contactNumber,
                "category": info.category,
                "promoCode": info.promoCode
            ]
        case .registerFb(let info):
            return info.toParam()
        case .forgotPasswordStep1(let email):
            return [
                "email": email
            ]
        case .forgotPasswordStep2(let email, let code):
            return [
                "email": email,
                "confirmCode": code
            ]
        case .forgotPasswordStep3(let email, let code, let newPwd, let confirmPwd):
            return [
                "email": email,
                "confirmCode": code,
                "newPassword": newPwd,
                "confirmPassword": confirmPwd
            ]
        default:
            return nil
        }
    }

    private func encoding(_ method: HTTPMethod) -> ParameterEncoding {
        switch method {
        case .get:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }

}
