//
//  VoteReprsentativeDetailViewController.swift
//  PoliticalAccountability
//
//  Created by Van Nguyen on 12/6/20.
//  Copyright © 2020 Spencer Ho's Hose. All rights reserved.
//

import Foundation
import UIKit

class VoteRepresentativeViewController: RepresentativeDetailViewController {
    
    var representative: Representative?
//    var parentView: MenuRepresentativeViewController?
//    var inProgress = false
//
    @IBOutlet weak var voteTableView: UITableView!
    
    var allVotes: [Vote] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        voteTableView.delegate = self
        voteTableView.dataSource = self
        self.inProgress = true
        ProPublicaHelper.getVotePositionsFromMemberID((representative?.bioguideID)!) { [self] result in
            do {
                let voteList = try result.get()
                self.allVotes = voteList
                
                DispatchQueue.main.async {
                    self.voteTableView.reloadData()
                    self.inProgress = false
                    self.parentView!.stopActivityIfOnMe(self)
                }
            } catch {
                print(error)
            }
        }
    }
}

extension VoteRepresentativeViewController: UITableViewDelegate, UITableViewDataSource {
    
    // TODO: Scrape all bills from congress.gov
    // TODO: Add sections based off of the vote categories (abortion, budget, etc)
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allVotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VoteCell") as! VoteTableCell
        let vote = allVotes[indexPath.row]
        
        if let billTitle = vote.billTitle, billTitle.count > 0 {
            cell.billTitleLabel.text = billTitle
        } else if let billDesc = vote.billDescription, billDesc.count > 0 {
            cell.billTitleLabel.text = billDesc
        } else {
            cell.billTitleLabel.text = "No title"
        }

        cell.originLabel.text = representative!.occupation == "sen" ? "Senate" : "House"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: vote.date!)!
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        cell.dateLabel.text = String(day) + " " + Constants.Conversions.monthIntToString[month-1] + " " + String(year)
        
        
        cell.voteImage.image = vote.didAgree! ? UIImage(named: "yesvote") : UIImage(named: "novote")
        
        return cell
    }
    
}
