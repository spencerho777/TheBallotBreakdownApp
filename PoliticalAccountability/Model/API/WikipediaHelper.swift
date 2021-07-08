//
//  WikipediaHelper.swift
//  PoliticalAccountability
//
//  Created by Van Nguyen on 12/29/20.
//  Copyright © 2020 Spencer Ho's Hose. All rights reserved.
//

import Foundation
import UIKit

struct WikiResult: Decodable {
    let query: Query
}
struct Query: Decodable {
    let pages: [Int: Page]
}
struct Page: Decodable {
    let pageid: Int
    let title: String
    let extract: String?
}

class WikipediaHelper {
    
    static func getIntroPargraphForMember(_ wikipediaTitle: String?, _ completion: @escaping (Result<String, Error>) -> Void) {
        
        guard let wikiTitle = wikipediaTitle else {
            completion(.failure(NSError(domain: "Wikipedia page does not exist", code: 404, userInfo: nil)))
            return
        }
        
        let searchQuery = wikiTitle.replacingOccurrences(of: " ", with: "_")
        let urlString = Constants.Wikipedia.APIURL + String(format: Constants.Wikipedia.introPath, searchQuery)
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Bad URL", code: 400, userInfo: nil)))
            return
        }
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url) { data, response, error in
            
            if let data = data {
                //print(String(data: data, encoding: .utf8))
                let decoder = JSONDecoder()
                if let items = try? decoder.decode(WikiResult.self, from: data), let page = Array(items.query.pages.values).first, let extract = page.extract {
                    completion(.success(extract))
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
    
}
