//
//  BillDetailViewController.swift
//  PoliticalAccountability
//
//  Created by Van Nguyen on 12/28/20.
//  Copyright © 2020 Spencer Ho's Hose. All rights reserved.
//

import Foundation
import UIKit

class BillDetailViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var billTitleTextView: UITextView!
    @IBOutlet weak var billStatusLabel: UILabel!
    @IBOutlet weak var billDateLabel: UILabel!
    @IBOutlet weak var billSummaryTextView: UITextView!
    @IBOutlet weak var votesLabel: UILabel!
    @IBOutlet weak var voteTableView: UITableView!
    @IBOutlet weak var readMoreButton: UIButton!
    
    // Injection
    var bill: Bill?
    
    
    // Global Variables
    var isSmartBill = false
    var detailedBill: DetailedBill?
    var actions = [SmartAction]()
    var highlight: String?
    var synopsis: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        voteTableView.delegate = self
        voteTableView.dataSource = self
        
        if let bill = self.bill {
            // Title
            var billHeader = bill.billNumber! + " "
            if let shortTitle = bill.billTitleShort {
                billHeader += shortTitle
            } else if let title = bill.billTitle {
                billHeader += title
            }
            billTitleTextView.text = billHeader
            
            if let smartID = bill.voteSmartID {
                self.isSmartBill = true
                // Vote smart key bill
                self.startIndicatingActivity()
                VoteSmartHelper.getBillFromSmartID(smartID) { result in
                    do {
                        let smartBill = try result.get()
                        for action in smartBill.actions.action {
                            print(action.stage, action.outcome, action.statusDate)
                        }
                        let sortedActions = smartBill.actions.action.sorted(by: {$0.statusDate < $1.statusDate}) as [SmartAction]
                        self.actions = sortedActions
                        
                        for action in sortedActions {
                            VoteSmartHelper.getActionFromActionID(action.actionId) { result in
                                do {
                                    let smartAction = try result.get()
                                    // print("Highlight: ", smartAction.highlight)
                                    // print("Synopsis: ", smartAction.synopsis)
                                    if smartAction.highlight != "" {
                                        self.highlight = smartAction.highlight
                                    }
                                    if smartAction.synopsis != "" {
                                        self.synopsis = smartAction.synopsis
                                    }
                                    
                                    if let sy = self.synopsis, self.highlight != nil {
                                        
                                        DispatchQueue.main.async {
                                            self.billSummaryTextView.text = sy
                                        }
                                    }
                                }
                                catch {
                                    print(error)
                                }
                            }
                            
                        }
                        // print(sortedActions.first, sortedActions.last)
                        DispatchQueue.main.async {
                            if let lastAction = sortedActions.last {
                                self.billDateLabel.text = Constants.Conversions.beautifyStringDate(dateString: lastAction.statusDate)
                                self.billStatusLabel.text = "Stage: " + lastAction.stage
                                self.voteTableView.reloadData()
                            }
                        }
                        self.stopIndicatingActivity()
                        
                        
                    }
                    catch {
                        debugPrint(error)
                    }
                }
            }
            else {
                // Normal bill
                billStatusLabel.text = bill.status
                billDateLabel.text = Constants.Conversions.beautifyDate(date: bill.date)
                self.highlight = bill.billSummary
                if bill.billSummaryShort != "" {
                    billSummaryTextView.text = bill.billSummaryShort
                    self.highlight = bill.billSummary
                }
                else {
                    billSummaryTextView.text = "Summary Not Availible"
                    readMoreButton.isHidden = true
                }
                votesLabel.text = "Votes Unavailible For This Bill"
                voteTableView.isHidden = true
            }
        }
    }
    @IBAction func readMoreButtonPressed(_ sender: Any) {
        let highlightDetailVC = self.storyboard?.instantiateViewController(identifier: "BillHighlightsViewController") as! BillHighlightsViewController
        highlightDetailVC.highlights = self.highlight
        highlightDetailVC.isSmartBill = self.isSmartBill
        navigationController?.pushViewController(highlightDetailVC, animated: true)
    }
}

extension BillDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 129
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "ActionCell") as! SmartActionTableCell
        let action = actions[indexPath.row]
        // print(rep)
        
        cell.stageLabel.text = action.stage
        cell.levelLabel.text = action.level
        cell.dateLabel.text = Constants.Conversions.beautifyStringDate(dateString: action.statusDate)
        
        if (action.yea == "" || action.nay == "") {
            cell.voteCountStackView.isHidden = true
            cell.outcomeImageView.image = UIImage(named: "yesvote")
        }
        else {
            cell.yeaVotesLabel.text = action.yea
            cell.nayVotesLabel.text = action.nay
            cell.outcomeImageView.image = action.outcome == "Passed" ? UIImage(named: "yesvote") : UIImage(named: "novote")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let action = actions[indexPath.row]
        
        if (action.yea != "" && action.nay != "") {
            let actionVotesVC = self.storyboard?.instantiateViewController(identifier: "BillActionVotesViewController") as! BillActionVotesViewController
            actionVotesVC.action = action
            navigationController?.pushViewController(actionVotesVC, animated: true)
        }
    }
}

extension BillDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset.x = 0
        }
    }
}
