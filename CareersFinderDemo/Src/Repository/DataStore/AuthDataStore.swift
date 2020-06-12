import Foundation
import RealmSwift

public protocol AuthDataStore {

    func saveAuth(_ auth: AuthEntity)
    func get() -> AuthEntity?
    func update(_ auth: AuthEntity)
    func remove()

}

public class AuthDataStoreImpl : AuthDataStore {

    public init() {
    }

    public func saveAuth(_ auth: AuthEntity) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(auth, update: true)
        }
    }

    public func get() -> AuthEntity? {
        var auth: AuthEntity? = nil
        let realm = try? Realm()
        auth = realm?.objects(AuthEntity.self).first
        return auth
    }

    public func update(_ auth: AuthEntity) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(auth, update: true)
        }
    }

    public func remove() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }

}
