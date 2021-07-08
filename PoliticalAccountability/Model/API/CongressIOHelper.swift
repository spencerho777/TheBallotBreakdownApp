//
//  DataworldHelper.swift
//  PoliticalAccountability
//
//  Created by Van Nguyen on 11/15/20.
//  Copyright © 2020 Spencer Ho's Hose. All rights reserved.
//

import Foundation
import UIKit
 
public class CongressIOHelper {
    
    static func getCongressmen(isHistorical: Bool, completion: @escaping ([Representative]?)-> Void) {
        let url = Constants.CongressIO.APIURL + (isHistorical ? Constants.CongressIO.histLegPath : Constants.CongressIO.curLegPath)
        //print(url)
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0
        )
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
                completion(nil)
            }
            else {
                //print(String(decoding: data!, as: UTF8.self))
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [[String:Any]] {
                        
                        var representativeList: [Representative] = []
                        for rep in json {
                            let representative = Representative(data: rep)
                            representativeList.append(representative)
                        }
                        if isHistorical {
                            representativeList = trimLegislatorsByYear(year: Constants.CongressIO.cutYear, repList: representativeList)
                            //print("\(json.count) -> \(representativeList.count) with cut year of \(Constants.CongressIO.cutYear)")
                        }
                        completion(representativeList)
                    }
                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                }
            }
        })
        dataTask.resume()
    }
    
    static func trimLegislatorsByYear(year: Int, repList: [Representative]) -> [Representative] {
        var result: [Representative] = []
        for rep in repList {
            if rep.endYear! >= year {
                result.append(rep)
            }
        }
        return result
    }
    
    static func getCongressPictureFromID(bioguideID: String, completion: @escaping (UIImage?) -> Void) {
        let url = Constants.CongressIO.APIURL + String(format: Constants.CongressIO.congressmenImagePath, "original", bioguideID)
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0
        )
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
                completion(nil)
            }
            else {
                if let data = data {
                    completion(UIImage(data: data))
                } else { completion(nil) }
            }
        })
        dataTask.resume()
    }
//
//    static func getCongressmenHistorical(search: String? = nil, limit: Int = 15, completion: @escaping ([Representative]?)-> Void) {
//        let headers = ["authorization": "Bearer \(Constants.Dataworld.APIToken)"]
//        let SQLCommand: String = "SELECT \(Constants.Dataworld.repInfoRequest) FROM legislators_historical ORDER BY last_name ASC LIMIT \(String(limit))".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
//        let query = "query=\(SQLCommand)"
//        let requestURL: String = "\(Constants.Dataworld.APIURL)\(Constants.Dataworld.APIPath)?\(query)"
//        let request = NSMutableURLRequest(url: NSURL(string: requestURL)! as URL,
//                                                cachePolicy: .useProtocolCachePolicy,
//                                            timeoutInterval: 10.0)
//        request.httpMethod = "GET"
//        request.allHTTPHeaderFields = headers
//
//        let session = URLSession.shared
//        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
//            if (error != nil) {
//                print(error)
//                completion(nil)
//            } else {
//                print(String(decoding: data!, as: UTF8.self))
//                completion(nil)
//            }
//        })
//
//        dataTask.resume()
//    }
//
//
//    static func getCongressmenAlphabetically(limit: Int = 15, completion: @escaping ([Representative]?)-> Void) {
//        let headers = ["authorization": "Bearer \(Constants.Dataworld.APIToken)"]
//        let SQLCommand: String = "SELECT \(Constants.Dataworld.repInfoRequest) FROM legislators_historical ORDER BY last_name ASC LIMIT \(String(limit))".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
//        let query = "query=\(SQLCommand)"
//        let requestURL: String = "\(Constants.Dataworld.APIURL)\(Constants.Dataworld.APIPath)?\(query)"
//        let request = NSMutableURLRequest(url: NSURL(string: requestURL)! as URL,
//                                                cachePolicy: .useProtocolCachePolicy,
//                                            timeoutInterval: 10.0)
//        request.httpMethod = "GET"
//        request.allHTTPHeaderFields = headers
//
//        let session = URLSession.shared
//        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
//          if (error != nil) {
//            print(error)
//            completion(nil)
//          } else {
////            let httpResponse = response as? HTTPURLResponse
////            print(httpResponse)
//            print(String(decoding: data!, as: UTF8.self))
//            completion(nil)
//          }
//        })
//
//        dataTask.resume()
//    }
    
}
