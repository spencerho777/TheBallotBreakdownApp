//
//  VoteSmartHelper.swift
//  PoliticalAccountability
//
//  Created by Van Nguyen on 1/7/21.
//  Copyright © 2021 Spencer Ho's Hose. All rights reserved.
//

import Foundation
import UIKit

/*
 struct VoteSmart {
     static let APIKey = "5b0789b8c984e09b0312864da73514c0"
     static let apiKeyVariable = "?key=" + APIKey
     static let outputJSONVariable = "&output=JSON&"
     static let APIURL = "http://api.votesmart.org/%@" + apiKeyVariable + outputJSONVariable
     
     static let getBillPath = "Votes.getBill" // requires billId
     static let getActionPath = "Votes.getBillAction" // requires actionId
     static let getVotesPath = "Votes.getByOfficial" // requires candidateId, optional officeId, categoryId, and year
     static let getActionVotesPath = "Votes.getBillActionVotes" // requires actionId
     static let getNPATPath = "Npag.getNpat" // requires candidateId
 }
 */
public class VoteSmartHelper {
    
    static func getVoteSmartIDFromBillNumber (type: String, billID: String, billTitle: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        let url = String(format: Constants.VoteSmart.APIURL, Constants.VoteSmart.getBillByNumberPath) + "billNumber=" + Constants.Conversions.billTypeToString[type]! + "_" + billID.components(separatedBy: ".").last!
        //print(url)
        
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0
        )
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if let error = error {
                completion(.failure(error))
            }
            else {
                //print(String(decoding: data!, as: UTF8.self))
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any]
                    if let result = json!["bills"] as? [String : Any] {
                        if let bills = result["bill"] as? [String : String] {
                            if let title = bills["title"], let votesmartID = bills["billId"], billTitle.levenshtein(title) < 10 {
                                completion(.success(votesmartID))
                                return
                            }
                        }
                    }
                    completion(.failure(NSError(domain: "No bills for this bill number", code: 100, userInfo: nil)))
                    return
                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                }
            }
        })
        dataTask.resume()
    }
    
    static func getRecentBills() {
        
    }
    
    static func getVoteCategories(_ year: String, _ completion: @escaping (Result<CategoryResult, Error>) -> Void) {
        let url = String(format: Constants.VoteSmart.APIURL, Constants.VoteSmart.getCategoryPath) + "year=" + year
        //print(url)
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0
            )
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) { data, response, error in
            
            if let data = data {
                //print(String(data: data, encoding: .utf8))
                let decoder = JSONDecoder()
                if let result = try? decoder.decode(CategoryJSON.self, from: data) {
                    completion(.success(result.categories))
                } else {
                    completion(.failure(NSError(domain: "Data could not be decoded", code: 400, userInfo: nil)))
                }
            }
            
            if let error = error {
                completion(.failure(error))
            }
        }
        dataTask.resume()
    }
    
    static func getBillsFromCategoryID(_ categoryID: String, year: String, _ completion: @escaping (Result<BillResult, Error>) -> Void) {
        let url = String(format: Constants.VoteSmart.APIURL, Constants.VoteSmart.getBillByCategoryPath) + "categoryId=" + categoryID + "&year=" + year
        //print(url)
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0
        )
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) { data, response, error in
            
            if let data = data {
                //print(String(data: data, encoding: .utf8))
                
                /*
                 
                 Future Spencer:
                 
                    You are working on inputting the bills from votesmart into the tableview. nothing complicated. Simply create a billcategory called the categoryName and use the bill format. Also, you must have a switch in tableview formatting depending on if KeyVotes was selected or AllVotes
                 
                 
                 */
                let decoder = JSONDecoder()
                if let result = try? decoder.decode(BillJSON.self, from: data) {
                    completion(.success(result.bills))
                } else {
                    completion(.failure(NSError(domain: "Data could not be decoded", code: 400, userInfo: nil)))
                }
            }
            
            if let error = error {
                completion(.failure(error))
            }
        }
        dataTask.resume()
    }
    
    static func getPCTFromCandidateID(_ candidateID: String, _ completion: @escaping (Result<PCTResult, Error>) -> Void) {
        let url = String(format: Constants.VoteSmart.APIURL, Constants.VoteSmart.getNPATPath) + "candidateId=" + candidateID
        //print(url)
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0
        )
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) { data, response, error in
            
            if let data = data {
                //print(String(data: data, encoding: .utf8))
                let decoder = JSONDecoder()
                if let result = try? decoder.decode(PCTJSON.self, from: data) {
                    completion(.success(result.npat))
                } else {
                    completion(.failure(NSError(domain: "Data could not be decoded", code: 400, userInfo: nil)))
                }
            }
            
            if let error = error {
                completion(.failure(error))
            }
        }
        dataTask.resume()
    }
    
    static func getBillFromSmartID(_ smartID: String, _ completion: @escaping (Result<VotesmartBillResult, Error>) -> Void) {
        let url = String(format: Constants.VoteSmart.APIURL, Constants.VoteSmart.getBillPath) + "billId=" + smartID
        print(url)
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0
        )
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) { data, response, error in
            
            if let data = data {
                //print(String(data: data, encoding: .utf8))
                let decoder = JSONDecoder()
                if let result = try? decoder.decode(VotesmartBillJSON.self, from: data) {
                    completion(.success(result.bill))
                } else {
                    completion(.failure(NSError(domain: "Data could not be decoded", code: 400, userInfo: nil)))
                }
            }
            
            if let error = error {
                completion(.failure(error))
            }
        }
        dataTask.resume()
    }
    
    static func getActionFromActionID(_ actionID: String, _ completion: @escaping (Result<VotesmartDetailedActionResult, Error>) -> Void) {
        let url = String(format: Constants.VoteSmart.APIURL, Constants.VoteSmart.getActionPath) + "actionId=" + actionID
        print(url)
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0
        )
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) { data, response, error in
            
            if let data = data {
                //print(String(data: data, encoding: .utf8))
                let decoder = JSONDecoder()
                if let result = try? decoder.decode(VotesmartDetailedActionJSON.self, from: data) {
                    completion(.success(result.action))
                } else {
                    completion(.failure(NSError(domain: "Data could not be decoded", code: 400, userInfo: nil)))
                }
            }
            
            if let error = error {
                completion(.failure(error))
            }
        }
        dataTask.resume()
    }
    
    static func getCandidateVotesFromActionID(_ actionID: String, _ completion: @escaping (Result<VotesmartCandidateVoteResult, Error>) -> Void) {
        let url = String(format: Constants.VoteSmart.APIURL, Constants.VoteSmart.getActionVotesPath) + "actionId=" + actionID
        print(url)
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0
        )
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) { data, response, error in
            
            if let data = data {
                //print(String(data: data, encoding: .utf8))
                let decoder = JSONDecoder()
                if let result = try? decoder.decode(VotesmartCandidateVoteJSON.self, from: data) {
                    completion(.success(result.votes))
                } else {
                    completion(.failure(NSError(domain: "Data could not be decoded", code: 400, userInfo: nil)))
                }
            }
            
            if let error = error {
                completion(.failure(error))
            }
        }
        dataTask.resume()
    }
    
    
    //static func getPCTFromCandidateID(_ candidateID: String, _ completion: @escaping (Result<PCTResult, Error>) -> Void) {
    
//    static func getVotePositionsFromMemberID(_ bioguideID: String, _ completion: @escaping (Result<[Vote], Error>) -> Void) {
//        let url = Constants.Propublica.APIURL + String(format: Constants.Propublica.votePositionPath, bioguideID)
//
//        extractJSONFromURL(url: url) { result in
//            do {
//                let data = try result.get()
//                if let voteJSON = data[0]["votes"] as? [[String:Any]] {
//                    var voteList: [Vote] = []
//                    for vote in voteJSON {
//                        let vote = Vote(data: vote)
//                        voteList.append(vote)
//                    }
//                    completion(.success(voteList))
//                }
//            } catch {
//                completion(.failure(error))
//            }
//        }
//     }
}
