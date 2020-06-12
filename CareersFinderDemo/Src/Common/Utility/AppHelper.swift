import Foundation

class AppHelper {
    
    public static let appStoreItemId: String = "itms-apps://itunes.apple.com/app/id1449408274"
    public static let appiOSUrl: String = "https://itunes.apple.com/kh/app/workingna/id1449408274?mt=8"
    public static let appAndroidUrl: String = "https://play.google.com/store/apps/details?id=com.mycareersfinder.workingna"
    public static let websiteUrl: String = "https://www.workingna.com"
    public static var shareFriend: String {
        return "iOS: \(appiOSUrl)\nAndroid: \(appAndroidUrl)"
    }
    
    public static func shareJobDetail(id: Int) -> String {
        return websiteUrl + "/jobs/detail?id=\(id)"
    }
    
}
