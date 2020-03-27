//
//  AppDelegate.swift
//  Corona Numbers
//
//  Created by Atahan on 20/03/2020.
//  Copyright © 2020 AtahanSahlan. All rights reserved.
//

import UIKit
//import GoogleMobileAds


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //GADMobileAds.sharedInstance().start(completionHandler: nil)

        let center = UNUserNotificationCenter.current()
               center.delegate = self
               center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
                   if granted {
                      // print("Permission granted")
                   } else {
                       //print("Permission denied\n")
                   }
               }
        
        if #available(iOS 13.0, *) {
            // In iOS 13 setup is done in SceneDelegate
        } else {
            let window = UIWindow(frame: UIScreen.main.bounds)
            self.window = window

                let mainstoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewcontroller:UIViewController = mainstoryboard.instantiateViewController(withIdentifier: "mainView") as! ViewController
                window.rootViewController = newViewcontroller
            
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

