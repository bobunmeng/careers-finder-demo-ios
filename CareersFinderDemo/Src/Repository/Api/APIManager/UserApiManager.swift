import Foundation
import Alamofire
import AlamofireObjectMapper
import RxSwift

class UserApiManager : BaseService {

    static let shared = UserApiManager()
    private let authDataStore: AuthDataStore

    private init() {
        self.authDataStore = AuthDataStoreImpl()
    }

    func login(email: String, password: String) -> Single<ModelWrapper<Auth>> {
        return Single.create { observer in
            self.request(Api.login(username: email, password: password))
                .responseObject(completionHandler: { (response: DataResponse<AuthResponse>) in
                    switch response.result {
                    case .success(let authResponse):
                        if authResponse.hasError() {
                            observer(.success(ModelWrapper(error: ErrorModel(authResponse.errorCode, authResponse.message))))
                            return
                        }
                        if authResponse.accessToken.isEmpty {
                            observer(.success(ModelWrapper(error: ErrorModel(message: "Unknown error!"))))
                            return
                        }
                        let auth = AuthEntity()
                        auth.id = authResponse.id
                        auth.accessToken = authResponse.accessToken
                        auth.expiredAt = authResponse.expiredAt
                        self.authDataStore.saveAuth(auth)
                        observer(.success(ModelWrapper(model: AuthTranslator().translate(entity: auth))))
                    case .failure(let error):
                        observer(.error(error))
                    }
                })
            return Disposables.create()
        }
    }

    func loginWithFacebook(userId: String) -> Single<ModelWrapper<Auth>> {
        return Single.create { observer in
            self.request(Api.fbLogin(userId: userId))
                .responseObject(completionHandler: { (response: DataResponse<AuthResponse>) in
                    switch response.result {
                    case .success(let authResponse):
                        if authResponse.accessToken.isEmpty {
                            observer(.success(ModelWrapper(error: ErrorModel(authResponse.errorCode, authResponse.message, authResponse.httpCode))))
                            return
                        }
                        let auth = AuthEntity()
                        auth.id = authResponse.id
                        auth.accessToken = authResponse.accessToken
                        auth.expiredAt = authResponse.expiredAt
                        self.authDataStore.saveAuth(auth)
                        observer(.success(ModelWrapper(model: AuthTranslator().translate(entity: auth))))
                    case .failure(let error):
                        observer(.error(error))
                    }
                })
            return Disposables.create()
        }
    }

    func register(registrationInfo: RegistrationInfo) -> Single<ModelWrapper<NoModel>> {
        return Single.create { observer in
            self.request(Api.register(registrationInfo: registrationInfo))
                .responseObject(completionHandler: { (response: DataResponse<AuthResponse>) in
                    switch response.result {
                    case .success(let authResponse):
                        if authResponse.hasError() {
                            observer(.success(ModelWrapper(error: ErrorModel(authResponse.errorCode, authResponse.message))))
                            return
                        }
                        if authResponse.accessToken.isEmpty {
                            observer(.success(ModelWrapper(error: ErrorModel(message: "Unknown error!"))))
                            return
                        }
                        let auth = AuthEntity()
                        auth.id = authResponse.id
                        auth.accessToken = authResponse.accessToken
                        auth.expiredAt = authResponse.expiredAt
                        self.authDataStore.saveAuth(auth)
                        observer(.success(ModelWrapper(model: NoModel(successful: true))))
                    case .failure(let error):
                        observer(.error(error))
                    }
                })

            return Disposables.create()
        }
    }
    
    func register(fbInfo: FacebookLoginInfo) -> Single<ModelWrapper<NoModel>> {
        return Single.create { observer in
            self.request(Api.registerFb(fbInfo: fbInfo))
                .responseObject(completionHandler: { (response: DataResponse<AuthResponse>) in
                    switch response.result {
                    case .success(let authResponse):
                        if authResponse.hasError() {
                            observer(.success(ModelWrapper(error: ErrorModel(authResponse.errorCode, authResponse.message))))
                            return
                        }
                        if authResponse.accessToken.isEmpty {
                            observer(.success(ModelWrapper(error: ErrorModel(message: "Unknown error!"))))
                            return
                        }
                        let auth = AuthEntity()
                        auth.id = authResponse.id
                        auth.accessToken = authResponse.accessToken
                        auth.expiredAt = authResponse.expiredAt
                        self.authDataStore.saveAuth(auth)
                        observer(.success(ModelWrapper(model: NoModel(successful: true))))
                    case .failure(let error):
                        observer(.error(error))
                    }
                })
            
            return Disposables.create()
        }
    }

    func forgotPassword(email: String) -> Single<ModelWrapper<User>> {
        return Single.create { observer in
            self.request(Api.forgotPasswordStep1(email: email))
                .responseObject(completionHandler: { (response: DataResponse<BaseResponse>) in
                    switch response.result {
                    case .success(let result):
                        if result.hasError() {
                            observer(.success(ModelWrapper(error: ErrorModel(result.errorCode, result.message))))
                            return
                        }
                        observer(.success(ModelWrapper(model: User())))
                    case .failure(let error):
                        observer(.error(error))
                    }
                })
            return Disposables.create()
        }
    }

    func forgotPassword(email: String, code: String) -> Single<ModelWrapper<User>> {
        return Single.create { observer in
            self.request(Api.forgotPasswordStep2(email: email, code: code))
                .responseObject(completionHandler: { (response: DataResponse<BaseResponse>) in
                    switch response.result {
                    case .success(let result):
                        if result.hasError() {
                            observer(.success(ModelWrapper(error: ErrorModel(result.errorCode, result.message))))
                            return
                        }
                        observer(.success(ModelWrapper(model: User())))
                    case .failure(let error):
                        observer(.error(error))
                    }
                })
            return Disposables.create()
        }
    }

    func forgotPassword(email: String, code: String, newPassword: String, confirmPassword: String) -> Single<ModelWrapper<User>> {
        return Single.create { observer in
            self.request(Api.forgotPasswordStep3(email: email, code: code, newPassword: newPassword, confirmPassword: confirmPassword))
                .responseObject(completionHandler: { (response: DataResponse<BaseResponse>) in
                    switch response.result {
                    case .success(let result):
                        var wrapper: ModelWrapper<User> = ModelWrapper(model: User())
                        if result.hasError() {
                            wrapper = ModelWrapper(error: ErrorModel(result.errorCode, result.message))
                        }
                        observer(.success(wrapper))
                    case .failure(let error):
                        observer(.error(error))
                    }
                })
            return Disposables.create()
        }
    }

}
