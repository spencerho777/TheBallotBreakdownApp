//
//  Cosponsorship.swift
//  PoliticalAccountability
//
//  Created by Van Nguyen on 12/5/20.
//  Copyright © 2020 Spencer Ho's Hose. All rights reserved.
//

import Foundation

class Bill {
    
    //MARK: - Metadata
    var billNumber: String?
    var billID: String?
    var billURI: String?
    var congressGovURL: String?
    
    //MARK: - Bill Details
    var type: String?
    var branch: String?
    var voteSmartID: String?
    var billTitle: String?
    var billTitleShort: String?
    var billSummary: String?
    var billSummaryShort: String?
    var primarySubject: String?
    var date: Date?
    var status = ""
    
    //MARK: - Member Position
    var sponsorParty: String?
    var cosponsors: [String:Int]?
    
    init (billNumber: String, billID: String?, type: String?, billURI: String?, voteSmartID: String?, congressGovURL: String?, branch: String?, billTitle: String?, billTitleShort: String?, primarySubject: String, date: Date?, billSummary: String, billSummaryShort: String?, sponsorParty: String?, cosponsors: [String:Int]?) {
        self.billNumber = billNumber
        self.billID = billID
        self.type = type
        self.billURI = billURI
        self.voteSmartID = voteSmartID
        self.congressGovURL = congressGovURL
        self.branch = branch
        self.billTitle = billTitle
        self.billTitleShort = billTitleShort
        self.primarySubject = primarySubject
        self.date = date
        self.billSummary = billSummary
        self.billSummaryShort = billSummaryShort
        self.sponsorParty = sponsorParty
        self.cosponsors = cosponsors
    }
    
    convenience init(data: [String:Any]) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.init(
            billNumber: data["number"] as! String,
            billID: data["bill_id"] as? String,
            type: nil, billURI: data["bill_uri"] as? String,
            voteSmartID: nil, congressGovURL: data["congressdotgov_url"] as? String,
            branch: data["bill_type"] as? String,
            billTitle: data["title"] as? String,
            billTitleShort: data["short_title"] as? String,
            primarySubject: data["primary_subject"] as! String,
            date: dateFormatter.date(from: data["introduced_date"] as! String)!,
            billSummary: data["summary"] as! String,
            billSummaryShort: data["summary_short"] as? String,
            sponsorParty: data["sponsor_party"] as? String,
            cosponsors: data["cosponsors_by_party"] as? [String:Int]
        )
    }
    func propertyNames() -> [String] {
        return Mirror(reflecting: self).children.compactMap { $0.label }
    }
}
