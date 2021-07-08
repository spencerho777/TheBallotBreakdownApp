//
//  BillActionVotesViewController.swift
//  PoliticalAccountability
//
//  Created by Van Nguyen on 6/18/21.
//  Copyright © 2021 Spencer Ho's Hose. All rights reserved.
//

import Foundation
import UIKit

class BillActionVotesViewController: UITableViewController {
    
    // Injection
    var action: SmartAction?
    
    // Global Variables
    var votes = [SmartVote]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.startIndicatingActivity()
        if let action = self.action {
            VoteSmartHelper.getCandidateVotesFromActionID(action.actionId) { result in
                do {
                    let votes = try result.get()
                    self.votes = votes.vote
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    self.stopIndicatingActivity()
                }
                catch {
                    print(error)
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - TableView Protocol
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return votes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "VoteCell") as! SmartVoteTableCell
        let vote = votes[indexPath.row]
        
        cell.repNameLabel.text = vote.candidateName
        cell.repPartyLabel.text = vote.officeParties
        cell.repVoteImageView.image = vote.action == "Yea" ? UIImage(named: "yesvote") : UIImage(named: "novote")
        
        return cell
    }
}

