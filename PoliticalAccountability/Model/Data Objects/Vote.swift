//
//  Vote.swift
//  PoliticalAccountability
//
//  Created by Van Nguyen on 11/14/20.
//  Copyright © 2020 Spencer Ho's Hose. All rights reserved.
//

import Foundation

class Vote {
    
    var billName: String?
    var didAgree: Bool?
    
    init (billName: String, didAgree: Bool) {
        self.billName = billName
        self.didAgree = didAgree
    }
}
