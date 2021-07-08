//
//  RepresentativeTableCell.swift
//  PoliticalAccountability
//
//  Created by Van Nguyen on 11/15/20.
//  Copyright © 2020 Spencer Ho's Hose. All rights reserved.
//

import Foundation
import UIKit

class RepresentativeTableCell: UITableViewCell {
    
    @IBOutlet weak var repImageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var occupation: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var party: UILabel!
    var onReuse: () -> Void = {}
    
    override func prepareForReuse() {
        super.prepareForReuse()
        onReuse()
        repImageView.image = nil
    }
}
