import Foundation
import ObjectMapper

class CategoryResponse : Mappable {

    public var id: Int = 0
    public var category: String = ""

    public required convenience init?(map: Map) {
        self.init()
    }

    public func mapping(map: Map) {
        id <- map["id"]
        category <- map["category"]
    }

}
