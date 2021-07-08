//
//  SponsorRepresentativeDetailViewController.swift
//  PoliticalAccountability
//
//  Created by Van Nguyen on 12/6/20.
//  Copyright © 2020 Spencer Ho's Hose. All rights reserved.
//

import Foundation
import UIKit

class SponsorRepresentativeViewController: RepresentativeDetailViewController {
    
    @IBOutlet weak var billTableView: UITableView!
    
    struct BillCategory {
        var headerTitle: String
        var bills: [Bill]
    }
    
    var representative: Representative?
//    var parentView: MenuRepresentativeViewController?
//    var inProgress = false
    
    var allBills: [BillCategory] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib.init(nibName: "BillTableCell", bundle: nil)
        self.billTableView.register(nib, forCellReuseIdentifier: "BillTableCell")
        billTableView.delegate = self
        billTableView.dataSource = self
        populateBillTable()
    }
    
    fileprivate func populateBillTable() {
        if let rep = representative {
            self.inProgress = true
            let bioguideID = rep.bioguideID!
            // TODO: Scrape congress.gov for "all bills"
            ProPublicaHelper.getCosponsoredBillsFromMemberID(bioguideID) { result in
                do {
                    let bills = try result.get()
                    self.allBills.append(BillCategory(headerTitle: "Cosponsored", bills: bills))
                    ProPublicaHelper.getIntroducedBillsFromMemberID(bioguideID) { [self] result in
                        do {
                            let bills = try result.get()
                            self.allBills.insert(BillCategory(headerTitle: "Sponsored", bills: bills), at: 0)
                            DispatchQueue.main.async {
                                self.billTableView.reloadData()
                                self.inProgress = false
                                self.parentView!.stopActivityIfOnMe(self)
                            }
                            
                        } catch { print(error) }
                    }
                } catch { print(error) }
            }
        }
    }
}

extension SponsorRepresentativeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return allBills.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allBills[section].bills.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return allBills[section].headerTitle
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BillTableCell") as! BillTableCell
        let bill = allBills[indexPath.section].bills[indexPath.row]
        
        var billHeader = bill.billNumber! + " "
        if let shortTitle = bill.billTitleShort {
            billHeader += shortTitle
        } else if let title = bill.billTitle {
            billHeader += title
        }
        cell.billTitleLabel.text = billHeader
        
        if let billSummaryShort = bill.billSummaryShort, billSummaryShort.count > 0 {
            cell.shortSummaryLabel.text = billSummaryShort
        } else if let billSummary = bill.billSummary, billSummary.count > 0 {
            cell.shortSummaryLabel.text = billSummary
        }
        else {
            cell.shortSummaryLabel.text = "There is no summary for this bill"
            cell.shortSummaryLabel.sizeToFit()
        }
        
        cell.billOriginLabel.text = bill.billNumber!.prefix(1) == "s" ? "Senate" : "House"
        
        if bill.sponsorParty! == "R" { cell.billOriginLabel.textColor = UIColor.red }
        else if bill.sponsorParty! == "D" { cell.billOriginLabel.textColor = UIColor.blue }
        else { cell.billOriginLabel.textColor = UIColor.black }
        
        
        if let date = bill.date {
            let calendar = Calendar.current
            let year = calendar.component(.year, from: date)
            let month = calendar.component(.month, from: date)
            let day = calendar.component(.day, from: date)
            cell.billDateLabel.text = String(day) + " " + Constants.Conversions.monthIntToString[month-1] + " " + String(year)
        }
            
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let bill = allBills[indexPath.section].bills[indexPath.row]
        //let cell = tableView.dequeueReusableCell(withIdentifier: "BillTableCell") as! BillTableCell
        guard bill.billNumber != "Empty" else {
            return
        }
        let billDetailVC = self.storyboard?.instantiateViewController(identifier: "BillDetailViewController") as! BillDetailViewController
        billDetailVC.bill = bill
        navigationController?.pushViewController(billDetailVC, animated: true)
    }
    
}
