//
//  ImageLoader.swift
//  PoliticalAccountability
//
//  Created by Van Nguyen on 11/20/20.
//  Copyright © 2020 Spencer Ho's Hose. All rights reserved.
//  credit: https://www.donnywals.com/efficiently-loading-images-in-table-views-and-collection-views/

import Foundation
import UIKit

class RepresentativeImageLoader {
    private var loadedImages = [String:UIImage]()
    private var runningRequests = [UUID:URLSessionDataTask]()
    
    func loadImage(bioguideID: String, completion: @escaping (Result<UIImage, Error>)-> Void) -> UUID? {
        

        if let image = loadedImages[bioguideID] {
            completion(.success(image))
            return nil
        }
        
        let uuid = UUID()
        
        let url = Constants.CongressIO.APIURL + String(format: Constants.CongressIO.congressmenImagePath, "original", bioguideID)
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
//            defer {
//                if self.runningRequests[uuid] != nil {
//                    self.runningRequests.removeValue(forKey: uuid)
//                }
//            }
            
            if let data = data {
                if let image = UIImage(data:data) {
                    completion(.success(image))
                    return
                } else {
                    completion(.success(UIImage(named: "no image availible")!))
                    return
                }
            }
            
            if let error = error as NSError? {
                completion(.failure(error))
                return
            }
            
        })
        dataTask.resume()
        runningRequests[uuid] = dataTask
        return uuid
    }
    
    func cancelLoad(_ uuid: UUID) {
        runningRequests[uuid]?.cancel()
        runningRequests.removeValue(forKey: uuid)
    }
    
    
}


/*
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
 */
 
