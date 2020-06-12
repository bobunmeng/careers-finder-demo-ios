import Foundation
import ObjectMapper
import Realm
import RealmSwift

@objcMembers
class CategoryEntity : Object, Mappable {

    dynamic var id: Int = 0
    dynamic var category: String = ""


    public required convenience init?(map: Map) {
        self.init()
    }

    public func mapping(map: Map) {
        id <- map["id"]
        category <- map["category"]
    }

    public override static func primaryKey() -> String? {
        return "id"
    }

}
