import Foundation
import Alamofire
import AlamofireObjectMapper

protocol BaseService {

    func request(_ api: Api) -> DataRequest
    func request(_ api: Api, _ auth: AuthEntity) -> DataRequest

}

extension BaseService {

    func request(_ api: Api) -> DataRequest {
        return Alamofire.request(api.urlRequest!)
    }

    func request(_ api: Api, _ auth: AuthEntity) -> DataRequest {
        var request = api.urlRequest!
//        if auth.isExpired() {
//             TODO: issue new token
//        }
        request.addValue("Token \(auth.accessToken)", forHTTPHeaderField: "Authorization")
        return Alamofire.request(request)
    }

}
