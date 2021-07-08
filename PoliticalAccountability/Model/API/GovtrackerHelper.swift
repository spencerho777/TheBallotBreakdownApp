//
//  GovtrackerHelper.swift
//  PoliticalAccountability
//
//  Created by Van Nguyen on 12/26/20.
//  Copyright © 2020 Spencer Ho's Hose. All rights reserved.
//

import Foundation
import SwiftSoup


// NOT ALLOWED I HATE MY LIFE

class GovtrackerHelper {
    
    static func getRepresentativeBiography(_ representative: Representative, _ completion: @escaping (Result<String, Error>) -> Void) {
        let url = Constants.Govtracker.APIURL + String(format: Constants.Govtracker.memberPath, String(representative.govtrackID!))
        

        do {
            let html = try! String(contentsOf: URL(string: url)!, encoding: .utf8)
            let doc: Document = try SwiftSoup.parseBodyFragment(html)

            // my body
            let body = doc.body()
            let bioDiv = try body?.getElementById("track_panel_base")!
            let bioText = try bioDiv!.select("p").first()!.text()
            let cleanedText = bioText.replacingOccurrences(of: "(view map)", with: "")
            completion(.success(cleanedText))
            //print("Header title: \(headerTitle)")
        } catch {
            completion(.failure(error))
        }

    }
}
