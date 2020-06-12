import UIKit
import Crashlytics
import Fabric
import FBSDKCoreKit
import GoogleMaps
import OneSignal
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Register FBSDK
//        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)

        // Register LinkedIn
        
        // Set up first screen to appear
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = SplashController.newInstance()

        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.tintColor = .white
        navigationBarAppearance.backgroundColor = UIColor(rgb: 0xCE3F3E)

//        self.registerRemoteNotification(application)

        // One Signal Configuration
//        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]
//
//        let oneSignalAppId = Bundle.main.infoDictionary?["OneSignalAppId"] as? String
//        OneSignal.initWithLaunchOptions(launchOptions,
//                                        appId: oneSignalAppId ?? "",
//                                        handleNotificationAction: nil,
//                                        settings: onesignalInitSettings)
//
//        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
//
//        // Google Maps
//        GMSServices.provideAPIKey("----")
//
        if let launchOptions =  launchOptions {
            if let info = launchOptions[UIApplicationLaunchOptionsKey.remoteNotification] as? [AnyHashable: Any] {
                viewControllerFromNotification(data: info)
            }
        }
        
        migrateRealm()

        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled = ApplicationDelegate.shared
            .application(app,
                         open: url,
                         sourceApplication: options[.sourceApplication] as? String,
                         annotation: options[.annotation])
        return handled
    }

}

extension AppDelegate {

    private func registerRemoteNotification(_ application: UIApplication) {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self

            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: { (_, _) in })
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
    }
    
}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        completionHandler([.alert, .badge, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)

        let data = response.notification.request.content.userInfo
        viewControllerFromNotification(data: data)
        completionHandler()
    }

    private func viewControllerFromNotification(data: [AnyHashable : Any]) {
        guard
            let custom = data[AnyHashable("custom")] as? NSDictionary,
            let a = custom["a"] as? NSDictionary,
            let customData = a["data"] as? NSDictionary,
            let actionId = customData["actionId"] as? Int
        else {
            return
        }
        let itemId = customData["itemId"] as? Int
        let splashScreen: SplashController = SplashController.newInstance()
        splashScreen.transitionType = .notification
        splashScreen.transitionValue = NotificationType(actionId: actionId, itemId: itemId ?? 0)
        self.window?.rootViewController = splashScreen
    }

}

