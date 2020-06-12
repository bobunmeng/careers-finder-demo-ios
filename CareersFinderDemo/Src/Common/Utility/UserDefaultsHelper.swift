import Foundation

class UserDefaultsHelper {
    
    private init() {}
    
    static func save(key: UserDefaultsKey, value: String) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    static func getValue(for key: UserDefaultsKey) -> String {
        return (UserDefaults.standard.value(forKey: key.rawValue) as? String) ?? ""
    }
    
    static func remove(key: UserDefaultsKey) {
        UserDefaults.standard.set(nil, forKey: key.rawValue)
    }
    
}

enum UserDefaultsKey: String {
    case loginWithSocial = "LogInWithSocial"
    case skipLogin = "SkipLogin"
}

enum UserDefaultsStaticValue: String {
    case loginWithSocial = "LogInWithSocial"
    case skipLogin = "SkipLogin"
}
