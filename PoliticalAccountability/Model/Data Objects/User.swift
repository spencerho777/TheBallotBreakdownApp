//
//  User.swift
//  PoliticalAccountability
//
//  Created by Van Nguyen on 11/14/20.
//  Copyright © 2020 Spencer Ho's Hose. All rights reserved.
//

import Foundation

class User: NSObject {
    
    var uid: String?
    var email: String?
    var multiFactorString: String?
    
    // var ref: DocumentReference?

    init(uid: String, email: String?, multiFactorString: String) {//}, ref: DocumentReference? = nil) {
        self.uid = uid
        if let email = email { self.email = email }
        self.multiFactorString = multiFactorString
    }
    
    convenience init(data: [String:Any]) {//, docRef: DocumentReference? = nil) {
        self.init(
            uid: data["uid"] as! String,
            email: data["email"] as? String,
            multiFactorString: data["multiFactorString"] as! String
        )
//        if let docRef = docRef {
//            self.ref = docRef
//        }
    }
    
    func getAttributes() -> [String:Any] {
        var attributes: [String:Any] = [:]
        if let uid = self.uid {attributes["uid"] = uid}
        if let email = self.email { attributes["email"] = email}
        if let multiFactorString = self.multiFactorString {attributes["multiFactorString"] = multiFactorString}
        
        return attributes
    }
    
}
