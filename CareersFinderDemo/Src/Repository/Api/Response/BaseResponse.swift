import Foundation
import ObjectMapper

class BaseResponse : Mappable {

    public var errorCode: Int? = nil
    public var message: String? = nil
    public var httpCode: Int? = nil

    public required convenience init?(map: Map) {
        self.init()
    }

    public func mapping(map: Map) {
        errorCode <- map["errorCode"]
        message <- map["message"]
        httpCode <- map["httpCode"]
    }

    public func hasError() -> Bool {
        return errorCode != nil || message != nil
    }

}
