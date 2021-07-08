//
//  Vote.swift
//  PoliticalAccountability
//
//  Created by Van Nguyen on 11/14/20.
//  Copyright © 2020 Spencer Ho's Hose. All rights reserved.
//

import Foundation

class Vote {
    
    //MARK: - Metadata
    var billID: String?
    var voteURI: String?
    
    //MARK: - Bill Details
    var billTitle: String?
    var billDescription: String?
    var date: String?
    
    //MARK: - Member Position
    var didAgree: Bool?
    
    init (billID: String?, voteURI: String?, billTitle: String?, billDescription: String, didAgree: Bool, date: String) {
        self.billID = billID
        self.voteURI = voteURI
        self.billTitle = billTitle
        self.billDescription = billDescription
        self.didAgree = didAgree
        self.date = date
    }
    
    convenience init(data: [String:Any]) {
        let bill = data["bill"] as! [String:Any]
        //print(bill)
        self.init(
            billID: bill["bill_id"] as? String,
            voteURI: data["vote_uri"] as? String,
            billTitle: bill["title"] as? String,
            billDescription: data["description"] as! String,
            didAgree: ((data["position"] as! String) == "Yes"),
            date: data["date"] as! String
        )
    }
}
