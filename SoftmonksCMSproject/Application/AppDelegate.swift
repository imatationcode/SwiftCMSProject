//
//  AppDelegate.swift
//  SoftmonksCMSproject
//
//  Created by Shivakumar Harijan on 16/02/24.
//

import UIKit
//import IQKeyboardManagerSwift
import TPKeyboardAvoiding

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let backButtonImage = UIImage(named: "arrowBack")?.withRenderingMode(.alwaysOriginal)
        UINavigationBar.appearance().backIndicatorImage = backButtonImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backButtonImage
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.clear], for: .normal)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.forEach { window in
                window.overrideUserInterfaceStyle = .light
            }
        }
        print(LogManager.shared.isLoggedIn)
        
        let token = UserDefaults.standard.object(forKey: "isLoggedIn")
        print("\(String(describing: token))")
        if (token != nil){
            print("in the token != nil")
            showMainScreen()
        } else{
            showLoginScreen()
          }
        return true
    }
    
    func showMainScreen() {
        print("About to launch profile")
        let mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileMenuVC")
        let navigationController = UINavigationController(rootViewController: mainVC)
        window?.rootViewController = navigationController
    }
    
    func showLoginScreen() {
        print("to Go Back LOgin")
        let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC")
        let navigationController = UINavigationController(rootViewController: loginVC)
        window?.rootViewController = navigationController
    }
    
    
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}
