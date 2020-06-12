import Foundation
import RealmSwift

class RealmHelper {

    static let sharedInstance = RealmHelper()
    private var _realm: Realm
    var realm: Realm {
        get {
            return _realm
        }
    }
    init() {
        _realm = try! Realm()
    }

}
