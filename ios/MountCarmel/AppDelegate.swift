//
//  AppDelegate.swift
//  MountCarmel
//
//  Created by Niraj on 29/02/20.
//  Copyright © 2020 InventionHill. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import GoogleSignIn
import FirebaseCore
import FirebaseMessaging

class GIDConfig{
    private init() {}
    static let shared = GIDConfig()
    let instance = GIDConfiguration.init(clientID: "531308145809-6b1f2itukpt6rdmslhhahkfo8dntjnbl.apps.googleusercontent.com")
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
//    var loginType: LoginType?
    var notificationUnreadCount : Int = 0
    var orientationLock = UIInterfaceOrientationMask.all
    private var _biometricAuthenticated = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
        self.manageApplicationRoot()
        Thread.sleep(forTimeInterval: 3.0)
        IQKeyboardManager.shared.enable = true
        
        ///// Set Firebase
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        /////  Set Notification
        self.SetupNotification(application: application)
        
        return true
    }
    
    func application(_ app: UIApplication,open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
      var handled: Bool

      handled = GIDSignIn.sharedInstance.handle(url)
      if handled {
        return true
      }

      // Handle other custom URL types.

      // If not handled by this app, return false.
      return false
    }
    
    func manageApplicationRoot() {
        if APP_DELEGATE.isLoggedIn {
            presentHostViewController()
        } else {
            presentSelectLoginTypeViewController()
        }
    }

    private func presentHostViewController() {
        guard let hostViewController: HostViewController = HostViewController.storyboardInstance.initialize() else {
            return
        }
        
        updateRootViewController(to: hostViewController)
    }
    
    private func presentSelectLoginTypeViewController() {
        guard let loginTypeViewController: SelectLoginTypeViewController = SelectLoginTypeViewController.storyboardInstance.initialize() else {
            return
        }
        
        let navigationController = UINavigationController()
        navigationController.viewControllers = [loginTypeViewController]
        navigationController.navigationBar.isHidden = true
        updateRootViewController(to: navigationController)
    }
    
    private func updateRootViewController(to viewController: UIViewController) {
        APP_DELEGATE.window?.rootViewController = viewController
        APP_DELEGATE.window?.makeKeyAndVisible()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        AppUpdater.shared.showUpdate(withConfirmation: false)
    }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "MountCarmel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

//MARK: - UNUserNotificationCenterDelegate
extension AppDelegate:UNUserNotificationCenterDelegate{
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(response)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print(notification)
        completionHandler([.alert, .badge, .sound])
    }
    
    private func SetupNotification(application:UIApplication){
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
          )
        } else {
          let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
    }
    
    
}

//MARK: - MessagingDelegate
extension AppDelegate:MessagingDelegate{
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        APP_DELEGATE.fcmToken = fcmToken ?? ""
        print(APP_DELEGATE.fcmToken)
        
    }

    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      Messaging.messaging().apnsToken = deviceToken
    }
    
    internal func UpdateFcmToken(){
        let request = fcmTokenRequest(token: APP_DELEGATE.fcmToken)
        Loader.show()
        if APP_DELEGATE.userType == .Staff{
            UserManagementAPI.updateStaffFcmToken(body: request) { response, error in
                Loader.hide()
                print(response?.message ?? "")
            }
        }else{
            UserManagementAPI.updateStudentFcmToken(body: request) { response, error in
                Loader.hide()
                print(response?.message ?? "")
            }
        }
    }
    
}


extension AppDelegate{
    
    var partStudentDetails : [String : Any]? {
        get {
            return UserDefaults.standard.dictionary(forKey: LPKeys.PART_STUDENT_DETAILS) ?? nil
        }
        set {
            UserDefaults.standard.set(newValue, forKey: LPKeys.PART_STUDENT_DETAILS)
        }
    }
    
    var isLoggedIn : Bool {
        get {
            return UserDefaults.standard.bool(forKey: LPKeys.IS_USER_LOGGED_IN)
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: LPKeys.IS_USER_LOGGED_IN)
        }
    }
    
    var userType : LoginType {
        get {
            return LoginType.init(rawValue: UserDefaults.standard.string(forKey: LPKeys.LOGIN_USER_TYPE) ?? "STAFF") ?? LoginType.Staff
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: LPKeys.LOGIN_USER_TYPE)
        }
    }
    
        var userID : String {
        get {
            return UserDefaults.standard.string(forKey: LPKeys.USER_ID) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: LPKeys.USER_ID)
        }
    }
    
    var tokenID : String {
        get {
            return UserDefaults.standard.string(forKey: LPKeys.USER_TOKEN_ID) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: LPKeys.USER_TOKEN_ID)
        }
    }
    
    var fcmToken : String {
        get {
            return UserDefaults.standard.string(forKey: LPKeys.FCM_TOKEN) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: LPKeys.FCM_TOKEN)
        }
    }
    
    var token : String {
        get {
            if let T = UserDefaults.standard.object(forKey: LPKeys.USER_TOKEN) as? String {
                return T
            }
            return ""
           // return UserDefaults.standard.string(forKey: LPKeys.USER_TOKEN+"New") ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: LPKeys.USER_TOKEN)
        }
    }
    
    var urlPath : String {
        get {
            return UserDefaults.standard.string(forKey: LPKeys.IMAGE_URL_PATH) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: LPKeys.IMAGE_URL_PATH)
        }
    }
    var strurlPath : String {
        get {
            return UserDefaults.standard.string(forKey: LPKeys.IMAGE_URL_PATH) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: LPKeys.IMAGE_URL_PATH)
        }
    }
    var parent_URL : String {
        get {
            return UserDefaults.standard.string(forKey: LPKeys.PARENT_IMAGE_URL_PATH) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: LPKeys.PARENT_IMAGE_URL_PATH)
        }
    }
    
    var userInfo : LoginAPIUser? {
        get {
            do {
                let cityData : Data = UserDefaults.standard.data(forKey: LPKeys.USER_INFO) ?? Data()
                return try JSONDecoder().decode(LoginAPIUser.self, from: cityData)
            } catch {
                print("Error while save city list")
                return nil
            }
        }
        set {
            do {
                let data = try JSONEncoder().encode(newValue)
                UserDefaults.standard.set(data, forKey: LPKeys.USER_INFO)
            } catch {
                print("Error while save city list")
            }
        }
    }
    var selected_Student : LoginAPIStudent? {
        get {
            do {
                let cityData : Data = UserDefaults.standard.data(forKey: LPKeys.SELECTED_STUDENT) ?? Data()
                return try JSONDecoder().decode(LoginAPIStudent.self, from: cityData)
            } catch {
                print("Error while save city list")
                return nil
            }
        }
        set {
            do {
                let data = try JSONEncoder().encode(newValue)
                UserDefaults.standard.set(data, forKey: LPKeys.SELECTED_STUDENT)
            } catch {
                print("Error while save city list")
            }
        }
    }
    
    var standardSectionData : StandardSection? {
        get {
            do {
                let studentStandardSectionData : Data = UserDefaults.standard.data(forKey: LPKeys.STUDENT_STANDARD_SECTION) ?? Data()
                return try JSONDecoder().decode(StandardSection.self, from: studentStandardSectionData)
            } catch {
                print("Error while getting standard section data")
                return nil
            }
        }
        set {
            do {
                let data = try JSONEncoder().encode(newValue)
                UserDefaults.standard.set(data, forKey: LPKeys.STUDENT_STANDARD_SECTION)
            } catch {
                print("Error while saving standard section data - \(String(describing: newValue))")
                UserDefaults.standard.set(nil, forKey: LPKeys.STUDENT_STANDARD_SECTION)
            }
        }
    }
    
    var loginAPIResponse : LoginAPIResponse? {
        get {
            do {
                let cityData : Data = UserDefaults.standard.data(forKey: LPKeys.LOGIN_API_RESPONSE) ?? Data()
                return try JSONDecoder().decode(LoginAPIResponse.self, from: cityData)
            } catch {
                print("Error while save city list")
                return nil
            }
        }
        set {
            do {
                let data = try JSONEncoder().encode(newValue)
                UserDefaults.standard.set(data, forKey: LPKeys.LOGIN_API_RESPONSE)
            } catch {
                print("Error while save city list")
            }
        }
    }
    
    var yearSession : String?{
        get{
            UserDefaults.standard.string(forKey: "yearSession")
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "yearSession")
        }
    }
    
    var currentAdmissionNumber : String?{
        get{
            UserDefaults.standard.string(forKey: "currentAdmissionNumber")
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "currentAdmissionNumber")
        }
    }
    
    var currentStaffBranch : String?{
        get{
            UserDefaults.standard.string(forKey: "currentStaffBranch")
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "currentStaffBranch")
        }
    }
    
    var student_Branch_code : Int?{
        get{
            UserDefaults.standard.integer(forKey: "student_Branch_code")
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "student_Branch_code")
        }
    }
    var student_LastStreamSelectionEnd_time : String?{
        get{
            UserDefaults.standard.string(forKey: "student_LastStreamSelectionEnd_time")
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "student_LastStreamSelectionEnd_time")
        }
    }
    var streamSelectionInfo : StreamData? {
        get {
            do {
                let cityData : Data = UserDefaults.standard.data(forKey: "streamSelectionInfo") ?? Data()
                return try JSONDecoder().decode(StreamData.self, from: cityData)
            } catch {
                print("Error while save city list")
                return nil
            }
        }
        set {
            do {
                let data = try JSONEncoder().encode(newValue)
                UserDefaults.standard.set(data, forKey: "streamSelectionInfo")
            } catch {
                print("Error while save city list")
            }
        }
    }
    
    var Show_transport_renewal_form : Bool{
        get{
            UserDefaults.standard.bool(forKey: "Show_transport_renewal_form")
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "Show_transport_renewal_form")
        }
    }
    
    var Show_transport_request : Bool {
        get{
            UserDefaults.standard.bool(forKey: "Show_transport_request")
        }set {
            UserDefaults.standard.setValue(newValue, forKey: "Show_transport_request")
        }
    }
    
    var year_session : String{
        get{
            UserDefaults.standard.string(forKey: "year_session") ?? ""
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "year_session")
        }
    }
    
    var isBiometricAuthenticated: Bool {
        get {
            self._biometricAuthenticated
        }
        set {
            self._biometricAuthenticated = newValue
        }
    }
    
    var enableFaceIDPromptNeeded: Bool {
        get {
            let storedValue = UserDefaults.standard.object(forKey: LPKeys.SHOW_ENABLE_FACEID_PROMPT) as? Bool
            return storedValue ?? true
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: LPKeys.SHOW_ENABLE_FACEID_PROMPT)
        }
    }
    
    func RemoveAllDefaults(){
        APP_DELEGATE.isLoggedIn = false
        APP_DELEGATE.isBiometricAuthenticated = false
        APP_DELEGATE.selected_Student = nil
        APP_DELEGATE.standardSectionData = nil
        BiometricAuthManager.shared.setBiometricService(enabled: false)
        UserDefaults.standard.set("", forKey: "ParentProfile")
        UserDefaults.standard.removeObject(forKey: "ParentProfile")
        UserDefaults.standard.removeObject(forKey: LPKeys.IS_USER_LOGGED_IN)
        UserDefaults.standard.removeObject(forKey: LPKeys.LOGIN_USER_TYPE)
        UserDefaults.standard.removeObject(forKey: LPKeys.USER_INFO)
        UserDefaults.standard.removeObject(forKey: LPKeys.LOGIN_API_RESPONSE)
        UserDefaults.standard.removeObject(forKey: LPKeys.USER_ID)
        UserDefaults.standard.removeObject(forKey: LPKeys.USER_TOKEN)
        UserDefaults.standard.removeObject(forKey: LPKeys.USER_TOKEN_ID)
        UserDefaults.standard.removeObject(forKey: "yearSession")
        UserDefaults.standard.removeObject(forKey: "currentAdmissionNumber")
        UserDefaults.standard.removeObject(forKey: "currentStaffBranch")
        UserDefaults.standard.removeObject(forKey: "StoryChecked")
        UserDefaults.standard.removeObject(forKey: LPKeys.SHOW_ENABLE_FACEID_PROMPT)
        
        APP_DELEGATE.manageApplicationRoot()
    }
}

extension AppDelegate{
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
            return (UIApplication.getTopViewController() as? Rotatable == nil) ? .portrait : .allButUpsideDown
    }
}

protocol Rotatable {}

extension UIApplication {
    
    class func getTopViewController(base: UIViewController? = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return getTopViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        if let controller = ((base as? HostViewController)?.children.last as? UINavigationController)?.viewControllers.last{
            return controller
        }
        return base
    }
}
