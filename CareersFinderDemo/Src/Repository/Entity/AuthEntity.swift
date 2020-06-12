import Foundation
import ObjectMapper
import Realm
import RealmSwift

@objcMembers
public class AuthEntity: Object, Mappable {

    dynamic var id: Int = 0
    dynamic var accessToken: String = ""
    dynamic var expiredAt: Date = Date()

    public required convenience init?(map: Map) {
        self.init()
    }

    public func mapping(map: Map) {
        id <- map["id"]
        accessToken <- map["accessToken"]
        expiredAt <- map["expiredAt"]
    }

    public override static func primaryKey() -> String? {
        return "id"
    }

    public func isExpired() -> Bool {
        return expiredAt < Date()
    }

}
