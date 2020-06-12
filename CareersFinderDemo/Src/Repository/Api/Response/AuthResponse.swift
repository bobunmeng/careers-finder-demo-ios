import Foundation
import ObjectMapper

class AuthResponse : BaseResponse {

    public var id: Int = 0
    public var accessToken: String = ""
    public var expiredAt: Date = Date()

    public required convenience init?(map: Map) {
        self.init()
    }

    public override func mapping(map: Map) {
        super.mapping(map: map)
        id <- map["id"]
        accessToken <- map["accessToken"]

        let formatter = ISO8601DateFormatter()
        if let expiry = map["expiredAt"].currentValue as? String,
            let date = formatter.date(from: expiry) {
            expiredAt = date
        }
    }

}
