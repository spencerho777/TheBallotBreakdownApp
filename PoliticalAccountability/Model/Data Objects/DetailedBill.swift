//
//  DetailedBill.swift
//  PoliticalAccountability
//
//  Created by Van Nguyen on 1/7/21.
//  Copyright © 2021 Spencer Ho's Hose. All rights reserved.
//

import Foundation

class DetailedBill {
    
    //MARK: - Metadata
    var billNumber: String?
    var billID: String?
    var billURI: String?
    var govtrackURL: String?
    
    //MARK: - Bill Details
    var branch: String?
    var billTitle: String?
    var billTitleShort: String?
    var billSummary: String?
    var billSummaryShort: String?
    var primarySubject: String?
    var introductionDate: Date?
    var billActions: [Action]?
    
    //MARK: - Member Position
    var billSponsorIDs: [String]?
    var sponsorParty: String?
    var cosponsors: [String:Int]?
    
    init (billNumber: String, billID: String, billURI: String, govtrackURL: String?, branch: String, billTitle: String?, billTitleShort: String?, primarySubject: String, introductionDate: Date, billSummary: String, billSummaryShort: String, sponsorParty: String, cosponsors: [String:Int]) {
        self.billNumber = billNumber
        self.billID = billID
        self.billURI = billURI
        self.govtrackURL = govtrackURL
        self.branch = branch
        self.billTitle = billTitle
        self.billTitleShort = billTitleShort
        self.primarySubject = primarySubject
        self.introductionDate = introductionDate
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
            billID: data["bill_id"] as! String,
            billURI: data["bill_uri"] as! String,
            govtrackURL: data["govtrack_url"] as? String,
            branch: data["bill_type"] as! String,
            billTitle: data["title"] as? String,
            billTitleShort: data["short_title"] as? String,
            primarySubject: data["primary_subject"] as! String,
            introductionDate: dateFormatter.date(from: data["introduced_date"] as! String)!,
            billSummary: data["summary"] as! String,
            billSummaryShort: data["summary_short"] as! String,
            sponsorParty: data["sponsor_party"] as! String,
            cosponsors: data["cosponsors_by_party"] as! [String:Int]
        )
    }
}
