//
//  VotesmartVote.swift
//  PoliticalAccountability
//
//  Created by Van Nguyen on 2/4/21.
//  Copyright © 2021 Spencer Ho's Hose. All rights reserved.
//

import Foundation

struct CategoryJSON: Decodable {
    var categories: CategoryResult
}

struct CategoryResult: Decodable {
    var category: [Category]
}

struct Category: Decodable {
    var categoryId: String
    var name: String
}

struct BillJSON: Decodable {
    var bills: BillResult
}

struct BillResult: Decodable {
    var bill: [SmartBill]
}

struct SmartBill: Decodable {
    var billId: String
    var billNumber: String
    var title: String
    var type: String // ex: Legislation, Nomination, etc
}
