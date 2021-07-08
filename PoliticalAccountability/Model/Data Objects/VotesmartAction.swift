//
//  VotesmartAction.swift
//  PoliticalAccountability
//
//  Created by Van Nguyen on 6/12/21.
//  Copyright © 2021 Spencer Ho's Hose. All rights reserved.
//

import Foundation

struct VotesmartDetailedActionJSON: Decodable {
    var action: VotesmartDetailedActionResult
}

struct VotesmartDetailedActionResult: Decodable {
    var billId: String
    var billNumber: String
    var actionId: String
    var stage: String
    var level: String
    var outcome: String
    var yea: String
    var nay: String
    var title: String
    var highlight: String
    var synopsis: String
    
}


//
//struct VotesmartBillJSON: Decodable {
//    var bill: VotesmartBillResult
//}
//
//struct VotesmartBillResult: Decodable {
//    var title: String
//    var type: String
//    var categories: BillCategoryResult
//    var sponsors: BillSponsorResult
//    var actions: BillActionResult
//}
//
//struct BillCategoryResult: Decodable {
//    var category: Category
//}
//
//struct BillSponsorResult: Decodable {
//    var sponsor: [SmartSponsor]
//    init (from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        do {
//            sponsor = try container.decode([SmartSponsor].self, forKey: .sponsor)
//        } catch {
//            let newValue = try container.decode(SmartSponsor.self, forKey: .sponsor)
//            sponsor = [newValue]
//        }
//        enum CodingKeys: String, CodingKey {
//            case sponsor
//        }
//    }
//}
//
//struct BillActionResult: Decodable {
//    var action: [SmartAction]
//    init (from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        do {
//            action = try container.decode([SmartAction].self, forKey: .action)
//        } catch {
//            let newValue = try container.decode(SmartAction.self, forKey: .action)
//            action = [newValue]
//        }
//        enum CodingKeys: String, CodingKey {
//            case action
//        }
//    }
//}
//
//struct SmartSponsor: Decodable {
//    var candidateId: String
//    var name: String
//    var type: String
//}
//
//struct SmartAction: Decodable {
//    var actionId: String
//    var level: String
//    var stage: String
//    var outcome: String
//    var statusDate: String
//}
