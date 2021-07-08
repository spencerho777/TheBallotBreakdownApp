//
//  Representative.swift
//  PoliticalAccountability
//
//  Created by Van Nguyen on 11/14/20.
//  Copyright © 2020 Spencer Ho's Hose. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Representative Class

class Representative: NSObject {
    
    // MARK: Metadata Properties
    var bioguideID: String?
    var govtrackID: Int?
    var wikipediaTitle: String?
    var voteSmartID: Int?
    
    // MARK: Biography Properties
    var firstName: String?
    var lastName: String?
    var birthdate: String?
    
    var picture: UIImage?
    
    // MARK: Political Properties
    var occupation: String?
    var startYear: Int?
    var endYear: Int?
    var state: String?
    var district: Int?
    var party: String?
    
    var recentVotes: [Vote]?
    
    // MARK: Initializer
    init(bioguideID: String, govtrackID: Int, wikipediaTitle: String?, voteSmartID: Int?, firstName: String, lastName: String, birthdate: String, occupation: String, startYear: Int, endYear: Int, state: String, district: Int, party: String) {
        self.bioguideID = bioguideID
        self.govtrackID = govtrackID
        self.wikipediaTitle = wikipediaTitle
        self.voteSmartID = voteSmartID
        self.firstName = firstName
        self.lastName = lastName
        self.birthdate = birthdate
        self.occupation = occupation
        self.startYear = startYear
        self.endYear = endYear
        self.state = state
        self.district = district
        self.party = party
    }
    
    convenience init(data: [String:Any]) {
        let repID = data["id"] as! [String:Any]
        let repBio = data["bio"] as! [String:Any]
        let repName = data["name"] as! [String:Any]
        let repTerms = data["terms"] as! [[String:Any]]
        let firstTerm = repTerms.first!
        let lastTerm = repTerms.last!
        
        self.init(
            bioguideID: repID["bioguide"] as! String,
            govtrackID: repID["govtrack"] as! Int,
            wikipediaTitle: repID["wikipedia"] as? String,
            voteSmartID: repID["votesmart"] as? Int,
            firstName: repName["first"] as! String,
            lastName: repName["last"] as! String,
            birthdate: (repBio["birthday"] as? String ?? "Unknown"),
            occupation: lastTerm["type"] as! String,
            startYear: Int(((firstTerm["start"] as! String).components(separatedBy: "-")).first!)!,
            endYear: Int(((lastTerm["end"] as! String).components(separatedBy: "-")).first!)!,
            state: lastTerm["state"] as! String,
            district: (lastTerm["district"] as? Int ?? -1),
            party: (lastTerm["party"] as? String ?? "Unknown")
        )
    }
    
    public override var description: String {
        return (self.firstName! + " " + self.lastName!)
    }
    
    /*struct Metadata {
        var bioguideID = ""
        var govtrackID = ""
    }
    
    struct Biography {
        var name: String = ""
        var age: Int = 0
    }
    
    struct Political {
        enum Occupation {
            case senate, house, retired
        }
        var State = "" // might become enum later
        var district = 0
        enum Party {
            case democrat, republican, independent, other
        }
    }*/
    
    
}

