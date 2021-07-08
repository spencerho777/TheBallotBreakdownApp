//
//  BillTableViewController.swift
//  PoliticalAccountability
//
//  Created by Van Nguyen on 12/20/20.
//  Copyright © 2020 Spencer Ho's Hose. All rights reserved.
//
//
//import Foundation
//import UIKit
//
//public class BillTableViewController: UITableViewDelegate, UITableViewDataSource  {
//
//    public func numberOfSections(in tableView: UITableView) -> Int {
//        return allBills.count
//    }
//
//    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return allBills[section].bills.count
//    }
//
//    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return allBills[section].headerTitle
//    }
//
//    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "BillCell") as! BillTableCell
//        let bill = allBills[indexPath.section].bills[indexPath.row]
//        
//        var billHeader = bill.billNumber! + " "
//        if let shortTitle = bill.billTitleShort {
//            billHeader += shortTitle
//        } else if let title = bill.billTitle {
//            billHeader += title
//        }
//        cell.billTitleLabel.text = billHeader
//        
//        if let billSummaryShort = bill.billSummaryShort, billSummaryShort.count > 0 {
//            cell.shortSummaryLabel.text = billSummaryShort
//        } else if let billSummary = bill.billSummary, billSummary.count > 0 {
//            cell.shortSummaryLabel.text = billSummary
//        }
//        else {
//            cell.shortSummaryLabel.text = "There is no summary for this bill"
//            cell.shortSummaryLabel.sizeToFit()
//        }
//        
//        cell.billOriginLabel.text = bill.billNumber!.prefix(1) == "s" ? "Senate" : "House"
//        
//        if bill.sponsorParty! == "R" { cell.billOriginLabel.textColor = UIColor.red }
//        else if bill.sponsorParty! == "D" { cell.billOriginLabel.textColor = UIColor.blue }
//        else { cell.billOriginLabel.textColor = UIColor.black }
//        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        let date = dateFormatter.date(from: bill.date!)!
//        let calendar = Calendar.current
//        let year = calendar.component(.year, from: date)
//        let month = calendar.component(.month, from: date)
//        let day = calendar.component(.day, from: date)
//        cell.billDateLabel.text = String(day) + " " + Constants.Conversions.monthIntToString[month-1] + " " + String(year)
//            
//        return cell
//    }
//}
