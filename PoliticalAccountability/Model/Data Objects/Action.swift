//
//  Action.swift
//  PoliticalAccountability
//
//  Created by Van Nguyen on 1/7/21.
//  Copyright © 2021 Spencer Ho's Hose. All rights reserved.
//

import Foundation

class Action {
    
    //MARK: - Metadata
    var actionID: String?
    
    //MARK: - Action Details
    var level: String?
    var stage: String?
    var outcome: String?
    var synopsis: String?
    
    //MARK: - Member Position
    var yesVotes: String?
    var noVotes: String?
    
    init(actionID: String, level: String, stage: String, outcome: String, synopsis: String, yesVotes: String, noVotes: String) {
        self.actionID = actionID
        self.level = level
        self.stage = stage
        self.outcome = outcome
        self.synopsis = synopsis
        self.yesVotes = yesVotes
        self.noVotes = noVotes
    }
    
    convenience init(data: [String:Any]) {
        self.init(actionID: data[""] as! String,
                  level: data[""] as! String,
                  stage: data[""] as! String,
                  outcome: data[""] as! String,
                  synopsis: data[""] as! String,
                  yesVotes: data[""] as! String,
                  noVotes: data[""] as! String)
    }
}
