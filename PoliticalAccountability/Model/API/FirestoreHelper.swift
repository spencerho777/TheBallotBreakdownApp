//
//  FirestoreHelper.swift
//  PoliticalAccountability
//
//  Created by Van Nguyen on 11/14/20.
//  Copyright © 2020 Spencer Ho's Hose. All rights reserved.
//
//
//import Foundation
//import UIKit
//import Firebase
//
//
//public class FirestoreHelper {
//
//    static var db: Firestore = AppDelegate.shared().db!
//
//
//    static func findUser(id: String, completion: @escaping (User?) -> Void ) {
//
//        let docRef = db.collection("users").whereField("uid", isEqualTo: id)
//
//
//        docRef.getDocuments() { (querySnapshot, err) in
//            if let err = err {
//                debugPrint("Error getting documents: \(err)")
//                //completion(nil)
//            } else {
//                if querySnapshot!.documents.count == 0 {
//                    debugPrint("User does not exist")
//                    completion(nil)
//                } else {
//                    debugPrint("USER FOUND")
//                    debugPrint("User data: \(querySnapshot!.documents[0].data())")
//                    let data = querySnapshot!.documents[0].data()
//                    let ref = querySnapshot!.documents[0].reference
//                    completion(User(data: data, docRef: ref))
//                }
//            }
//        }
//    }
//
//    static func addUserToDatabase( user: User ) {
//
//        // FEATURE: Add all the other user shit into the database
//        var ref: DocumentReference? = nil
//
//        ref = FirestoreHelper.db.collection("users").addDocument(data: user.getAttributes()) { err in
//            if let err = err {
//                debugPrint("Error adding document: \(err)")
//            } else {
//                debugPrint("User addeed with ID: \(ref!.documentID)")
//                user.ref = ref
//            }
//        }
//    }
//
//}
