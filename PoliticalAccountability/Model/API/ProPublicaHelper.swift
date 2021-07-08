//
//  ProPublicaHelper.swift
//  PoliticalAccountability
//
//  Created by Van Nguyen on 11/25/20.
//  Copyright © 2020 Spencer Ho's Hose. All rights reserved.
//

import Foundation
import UIKit

public class ProPublicaHelper {
    
    static func getVotePositionsFromMemberID(_ bioguideID: String, _ completion: @escaping (Result<[Vote], Error>) -> Void) {
        let url = Constants.Propublica.APIURL + String(format: Constants.Propublica.votePositionPath, bioguideID)
        
        extractJSONFromURL(url: url) { result in
            do {
                let data = try result.get()
                if let voteJSON = data[0]["votes"] as? [[String:Any]] {
                    var voteList: [Vote] = []
                    for vote in voteJSON {
                        let vote = Vote(data: vote)
                        voteList.append(vote)
                    }
                    completion(.success(voteList))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    static func getRecentBills(_ type: String, _ completion: @escaping(Result<[Bill], Error>) -> Void) {
        let url = Constants.Propublica.APIURL + String(format: Constants.Propublica.recentBillsPath, type.lowercased())
        extractJSONFromURL(url: url) { result in
            do {
                let data = try result.get()
                if let billJSON = data[0]["bills"] as? [[String:Any]] {
                    var billList: [Bill] = []
                    for bill in billJSON {
                        let bill = Bill(data: bill)
                        bill.status = type
                        billList.append(bill)
                    }
                    completion(.success(billList))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    static func searchBillsFromQuery(_ query: String, _ completion: @escaping(Result<[Bill], Error>) -> Void) {
        guard let searchQuery = ("\"" + query + "\"").addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            completion(.failure(NSError()))
            return
        }
        let url = Constants.Propublica.APIURL + String(format: Constants.Propublica.searchBillsPath, searchQuery)
        
        extractJSONFromURL(url: url) { result in
            do {
                let data = try result.get()
                if let billJSON = data[0]["bills"] as? [[String:Any]] {
                    var billList: [Bill] = []
                    for bill in billJSON {
                        let bill = Bill(data: bill)
                        //print(bill.date)
                        billList.append(bill)
                    }
                    completion(.success(billList))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    static func getIntroducedBillsFromMemberID(_ bioguideID: String, _ completion: @escaping (Result<[Bill], Error>) -> Void) {
        let url = Constants.Propublica.APIURL + String(format: Constants.Propublica.sponsorshipPath, bioguideID, "introduced")
        
        extractJSONFromURL(url: url) { result in
            do {
                let data = try result.get()
                if let billJSON = data[0]["bills"] as? [[String:Any]] {
                    var billList: [Bill] = []
                    for bill in billJSON {
                        let bill = Bill(data: bill)
                        billList.append(bill)
                    }
                    completion(.success(billList))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    static func getCosponsoredBillsFromMemberID(_ bioguideID: String, _ completion: @escaping (Result<[Bill], Error>) -> Void) {
        let url = Constants.Propublica.APIURL + String(format: Constants.Propublica.cosponsorshipPath, bioguideID)
        extractJSONFromURL(url: url) { result in
            do {
                let data = try result.get()
                if let billJSON = data[0]["bills"] as? [[String:Any]] {
                    var billList: [Bill] = []
                    
                    for bill in billJSON {
                        let bill = Bill(data: bill)
                        billList.append(bill)
                    }
                    completion(.success(billList))
                }
                
            } catch {
                completion(.failure(error))
            }
        }
    }

    static func extractJSONFromURL(url: String, _ completion: @escaping (Result<[[String:Any]], Error>) -> Void) {
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0
        )
        request.addValue(Constants.Propublica.APIKey, forHTTPHeaderField: "X-API-Key")
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            if let data = data {
                //print(String(data: data, encoding: .utf8))
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                        
                        if let resultJSON = json["results"] as? [[String:Any]] {
                            //print(resultJSON)
                            completion(.success(resultJSON))
                        }
                        
                    }
                } catch let jsonError as NSError {
                    print("Failed to load: \(jsonError.localizedDescription)")
                    completion(.failure(jsonError))
                }
            }
            
            if let error = error {
                completion(.failure(error))
            }
        })
        dataTask.resume()
    }
    
}
    
