//
//  AppDelegate.swift
//  PoliticalAccountability
//
//  Created by Van Nguyen on 11/14/20.
//  Copyright © 2020 Spencer Ho's Hose. All rights reserved.
//

import UIKit
//import Firebase
//import FirebaseUI
import DropDown

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
//    var db: Firestore?
//    var storage: Storage?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        DropDown.startListeningToKeyboard()
//
//        FirebaseApp.configure()
//        db = Firestore.firestore()
//        storage = Storage.storage()
        
        //print(window?.rootViewController)
//        let navigationController = window?.rootViewController as! FirstNavigationController
//        let tabBarController = window?.rootViewController as! StartingTabBarController
//        for controller in tabBarController.children {
//            if let AuthController = controller as? AuthorizationController {
//                //AuthController.db = db
//            }
//        }
        
        return true
    }

    static func shared() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      // Pass device token to auth
      //Auth.auth().setAPNSToken(deviceToken, type: .prod)
    }
}

