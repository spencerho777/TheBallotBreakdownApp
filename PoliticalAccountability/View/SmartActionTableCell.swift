//
//  SmartActionTableCell.swift
//  PoliticalAccountability
//
//  Created by Van Nguyen on 6/13/21.
//  Copyright © 2021 Spencer Ho's Hose. All rights reserved.
//

import Foundation
import UIKit

class SmartActionTableCell: UITableViewCell {
    
    @IBOutlet weak var stageLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var voteCountStackView: UIStackView!
    @IBOutlet weak var yeaVotesLabel: UILabel!
    @IBOutlet weak var nayVotesLabel: UILabel!
    @IBOutlet weak var outcomeImageView: UIImageView!
    
}
