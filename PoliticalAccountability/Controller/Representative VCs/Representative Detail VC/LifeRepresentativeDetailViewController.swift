//
//  LifeRepresentativeDetailViewController.swift
//  PoliticalAccountability
//
//  Created by Van Nguyen on 12/6/20.
//  Copyright © 2020 Spencer Ho's Hose. All rights reserved.
//

import Foundation
import UIKit
import SwiftSoup

class LifeRepresentativeViewController: RepresentativeDetailViewController {
    
    var representative: Representative?
//    var parentView: MenuRepresentativeViewController?
//    var inProgress = false
    
    @IBOutlet weak var repImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var occupationLabel: UILabel!
    @IBOutlet weak var biographyLabel: UITextView!
    
    let imageLoader = RepresentativeImageLoader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let rep = representative {
            
            self.inProgress = true
            let _ = imageLoader.loadImage(bioguideID: rep.bioguideID!, completion: { [self] result in
                do {
                    let image = try result.get()
                    
                    DispatchQueue.main.async {
                        self.repImageView.image = image
                        self.inProgress = false
                        self.parentView!.stopActivityIfOnMe(self)
                    }
                } catch {
                    print(error)
                }
            })
            nameLabel.text = rep.firstName! + " " + rep.lastName!
            occupationLabel.text = Constants.Conversions.abbreviationToOccupationName[rep.occupation!]! + " of " + Constants.Conversions.abbreviationToStateName[rep.state!]!
        }
        DispatchQueue.global(qos: .background).async {
            
            WikipediaHelper.getIntroPargraphForMember(self.representative!.wikipediaTitle) { result in
                do {
                    let biographyText = try result.get()

                    DispatchQueue.main.async {
                        self.biographyLabel.text = biographyText
                    }
                } catch {
                    print(error)
                    DispatchQueue.main.async {
                        self.biographyLabel.text = "No Biography Found"
                    }
                }
            }
        }
    }

}
