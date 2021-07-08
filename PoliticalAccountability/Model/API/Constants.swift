//
//  ProPublicaConstants.swift
//  PoliticalAccountability
//
//  Created by Van Nguyen on 11/14/20.
//  Copyright © 2020 Spencer Ho's Hose. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Constants

struct Constants {
    
    // MARK: - Conversions
    struct Conversions {
        static let abbreviationToOccupationName: [String: String] = [
            "sen" : "Senator",
            "rep" : "Representative"
        ]
        static let abbreviationToStateName: [String : String] = [
        "AK" : "Alaska",
        "AL" : "Alabama",
        "AR" : "Arkansas",
        "AS" : "American Samoa",
        "AZ" : "Arizona",
        "CA" : "California",
        "CO" : "Colorado",
        "CT" : "Connecticut",
        "DC" : "District of Columbia",
        "DE" : "Delaware",
        "FL" : "Florida",
        "GA" : "Georgia",
        "GU" : "Guam",
        "HI" : "Hawaii",
        "IA" : "Iowa",
        "ID" : "Idaho",
        "IL" : "Illinois",
        "IN" : "Indiana",
        "KS" : "Kansas",
        "KY" : "Kentucky",
        "LA" : "Louisiana",
        "MA" : "Massachusetts",
        "MD" : "Maryland",
        "ME" : "Maine",
        "MI" : "Michigan",
        "MN" : "Minnesota",
        "MO" : "Missouri",
        "MS" : "Mississippi",
        "MT" : "Montana",
        "NC" : "North Carolina",
        "ND" : "North Dakota",
        "NE" : "Nebraska",
        "NH" : "New Hampshire",
        "NJ" : "New Jersey",
        "NM" : "New Mexico",
        "NV" : "Nevada",
        "NY" : "New York",
        "OH" : "Ohio",
        "OK" : "Oklahoma",
        "OR" : "Oregon",
        "MP" : "Northern Mariana Islands",
        "PA" : "Pennsylvania",
        "PR" : "Puerto Rico",
        "RI" : "Rhode Island",
        "SC" : "South Carolina",
        "SD" : "South Dakota",
        "TN" : "Tennessee",
        "TX" : "Texas",
        "UT" : "Utah",
        "VA" : "Virginia",
        "VI" : "Virgin Islands",
        "VT" : "Vermont",
        "WA" : "Washington",
        "WI" : "Wisconsin",
        "WV" : "West Virginia",
        "WY" : "Wyoming"]
        static let monthIntToString = ["January","February","March","April","May","June","July",
        "August","September","October","November","December"]
        static let timePeriodLabelToInt = [
            "Current" : 0,
            "10 years" : 10,
            "50 years" : 50,
            "100 years" : 100,
            "All": 300
        ]
        static let billTypeToString = [
            "hr" : "HR",
            "s" : "S",
            "hres" : "H_Res",
            "hjres" : "H_J_Res",
            "sjres" : "S_J_Res",
            "hconres" : "H_Con_Res",
            "sconres" : "S_Con_Res"
        ]
        
        static func beautifyDate(date: Date?) -> String {
            if let date = date {
                let calendar = Calendar.current
                let year = calendar.component(.year, from: date)
                let month = calendar.component(.month, from: date)
                let day = calendar.component(.day, from: date)
                return String(day) + " " + Constants.Conversions.monthIntToString[month-1] + " " + String(year)
            }
            return ""
        }
        
        static func beautifyStringDate(dateString: String?) -> String {
            if let dateString = dateString {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let date = dateFormatter.date(from: dateString)
                return beautifyDate(date: date)
            }
            return ""
        }
    }
    
    // MARK: - Propublica API
    
    struct Propublica {
        static let APIURL = "https://api.propublica.org/congress/v1/"
        static let APIKey = "WcmSS08gZhhZp6dDxQeByzA7YeivhwZ0jEANjp7l" // obfuscate later perhaps
        static let votePositionPath = "members/%@/votes.json" // member ID
        static let sponsorshipPath = "members/%@/bills/%@.json" // member ID, type of action (ex introduced, enacted, etc)
        static let cosponsorshipPath = "members/%@/bills/cosponsored.json" // member ID
        static let recentBillsPath = "117/both/bills/%@.json" // congress (105-116). type of action (ex introduced, enacted, etc)
        static let searchBillsPath = "bills/search.json?query=%@&sort=_score&dir=desc" // search query
    }
    
    // MARK: - Ballotpedia
    
    // MARK: - GovTracker
    struct Govtracker {
        static let APIURL = "https://www.govtrack.us/congress"
        static let memberPath = "/members/%@"
    }
    
    // MARK: - Votesmart
    struct VoteSmart {
        static let APIKey = "5b0789b8c984e09b0312864da73514c0"
        static let apiKeyVariable = "?key=" + APIKey
        static let outputJSONVariable = "&o=JSON&"
        static let APIURL = "http://api.votesmart.org/%@" + apiKeyVariable + outputJSONVariable
        
        static let getBillByNumberPath = "Votes.getByBillNumber" // requires billNumber
        static let getBillPath = "Votes.getBill" // requires billId
        static let getActionPath = "Votes.getBillAction" // requires actionId
        static let getVotesPath = "Votes.getByOfficial" // requires candidateId, optional officeId, categoryId, and year
        static let getActionVotesPath = "Votes.getBillActionVotes" // requires actionId
        static let getNPATPath = "Npat.getNpat" // requires candidateId
        static let getCategoryPath = "Votes.getCategories" // requires year
        static let getBillByCategoryPath = "Votes.getBillsByCategoryYearState" // requires categoryid, optional year
    }
    
    // MARK: - Data.world
    
    struct Dataworld {
        static let APIURL = "https://api.data.world/v0/"
        static let APIPath = "sql/govtrack/us-congress-legislators"
        static let DwUsername = "spencewert"
        static let APIToken = "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJwcm9kLXVzZXItY2xpZW50OnNwZW5jZXdlcnQiLCJpc3MiOiJhZ2VudDpzcGVuY2V3ZXJ0Ojo3N2Y2MzU1Ni05MTY5LTRiZGMtODRmNy04MzJlNmRlODczZjYiLCJpYXQiOjE2MDU0MTcwODYsInJvbGUiOlsidXNlcl9hcGlfcmVhZCIsInVzZXJfYXBpX3dyaXRlIl0sImdlbmVyYWwtcHVycG9zZSI6dHJ1ZSwic2FtbCI6e319.aMvucq8K5c-VsJQsdcE30WGwBKTEOmrB8Wrcze5gVVVEBpaLbvOQTzXcjkhY807PLvD6qQ_V_jcEP6xQnCG5Jg"
        static let repInfoRequest = "first_name, last_name, bioguide_id, govtrack_id, birthday_bio"
        
    }
    
    // MARK: - Wikipedia
    struct Wikipedia {
        static let APIURL = "https://en.wikipedia.org/w/api.php?"
        static let introPath = "action=query&titles=%@&prop=extracts&format=json&exintro=1&explaintext=1" // title
    }
    
    // MARK: - Congress.io
    struct CongressIO {
        static let APIURL = "https://theunitedstates.io"
        static let histLegPath = "/congress-legislators/legislators-historical.json"
        static let curLegPath = "/congress-legislators/legislators-current.json"
        static let cutYear = 1950
        static let congressmenImagePath = "/images/congress/%@/%@.jpg"
    }
}
