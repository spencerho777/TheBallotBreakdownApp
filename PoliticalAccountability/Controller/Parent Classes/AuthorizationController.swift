//
//  AuthorizationProtocol.swift
//  PoliticalAccountability
//
//  Created by Van Nguyen on 11/14/20.
//  Copyright © 2020 Spencer Ho's Hose. All rights reserved.
//

import Foundation
//import Firebase
//import FirebaseUI
import UIKit

class AuthorizationController: UIViewController {
//    fileprivate(set) var auth: Auth?
//    fileprivate(set) var authUI: FUIAuth? //only set internally but get externally
//    fileprivate(set) var authStateListenerHandle: AuthStateDidChangeListenerHandle?
//
//    var db: Firestore!
    var currentUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let accountButton = UIBarButtonItem(image: UIImage(named: "ic_account_circle.png"), style: .plain, target: self, action: #selector(accountButtonPressed(sender:)))
//        self.navigationItem.leftBarButtonItem  = accountButton
        
        //setUpAuth()
    }
    
    @objc func accountButtonPressed(sender: UIBarButtonItem) {
//        loginAction(sender: self)
    }
    
}

// extension AuthorizationController: FUIAuthDelegate {
//     fileprivate func setUpAuth() {
//        self.auth = Auth.auth()
//        self.authUI = FUIAuth.defaultAuthUI()
//        self.authUI?.delegate = self
//        self.authUI?.providers = [
//            FUIGoogleAuth(),
//            FUIPhoneAuth(authUI: self.authUI!), // FEATURE: Add push notifications in "Capabilities Section"
//            FUIEmailAuth()
//        ]
//
//        self.authStateListenerHandle = self.auth?.addStateDidChangeListener { (auth, user) in
//            /*guard user != nil else {
//                self.loginAction(sender: self)
//                return
//            }*/
//            if let user = user {
//                var multiFactorString = "MultiFactor: "
//                for info in user.multiFactor.enrolledFactors {
//                    multiFactorString += info.displayName ?? "[DisplayName]"
//                    multiFactorString += " "
//                }
//                self.currentUser = User(uid: user.uid, email: user.email, multiFactorString: multiFactorString)
//                FirestoreHelper.findUser(id: user.uid) { (user) in
//                    if user == nil {
//                        FirestoreHelper.addUserToDatabase(user: self.currentUser!)
//                    } else { self.currentUser!.ref = user!.ref }
//                }
//                // TODO: Toggle Icon based on log in status
//                //self.toggleLoggingButtons()
//            }
//        }
//    }
    
//    func loginAction(sender: AnyObject) {
//        let authViewController = authUI?.authViewController()
//        self.show(authViewController!, sender: self)
//    }
    
//    private func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
//        guard let authError = error else { return }
//
//        let errorCode = UInt((authError as NSError).code)
//
//        switch errorCode {
//        case FUIAuthErrorCode.userCancelledSignIn.rawValue:
//            print("User cancelled sign-in")
//            break
//
//        default:
//            let detailedError = (authError as NSError).userInfo[NSUnderlyingErrorKey] ?? authError
//            print("Login error: \((detailedError as! NSError).localizedDescription)")
//        }
//    }
//}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
