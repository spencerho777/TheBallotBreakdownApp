//
//  BrowseBillsViewController.swift
//  PoliticalAccountability
//
//  Created by Van Nguyen on 11/14/20.
//  Copyright © 2020 Spencer Ho's Hose. All rights reserved.
//

import Foundation
import UIKit
import DropDown

class BrowseBillsViewController: AuthorizationController {
    
    @IBOutlet weak var billTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var keyBillsButton: UIButton!
    @IBOutlet weak var allBillsButton: UIButton!

    struct BillCategory {
        var headerTitle: String
        var bills: [Bill]
    }
    var allBills: [BillCategory] = []
    var categories = [Category]()
    var categoryNames = [String]()
    
    var categoryDropDown = DropDown()
    var yearDropDown = DropDown()
    var selectedCategory: Category?
    var selectedYear: String?
    var keyVotesSelected = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        let nib = UINib.init(nibName: "BillTableCell", bundle: nil)
        self.billTableView.register(nib, forCellReuseIdentifier: "BillTableCell")
        billTableView.delegate = self
        billTableView.dataSource = self
        configureDropDowns()
        self.searchBar.delegate = self
        
    }
    
    @IBAction func keyVoteButtonPressed(_ sender: Any) {
        yearDropDown.show()
    }
    
    @IBAction func allVotesButtonPressed(_ sender: Any) {
        self.keyVotesSelected = false
        allVotesPopulate()
    }
    
}

extension BrowseBillsViewController {
    func getCategoryListForYear(_ year: String, _ completion: @escaping (Bool) -> Void) {
        VoteSmartHelper.getVoteCategories(year) { result in
            do {
                let categoryResult = try result.get()
                let categoryList = categoryResult.category
                self.categories = categoryList
                self.categoryNames = []
                for c in categoryResult.category {
                    self.categoryNames.append(c.name)
                }
                completion(true)
            }
            catch {
                print("Could not get categories")
                completion(false)
            }
        }
    }
}

extension BrowseBillsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func keyVotesPopulate(_ completion: @escaping (Bool) -> Void) {
        self.startIndicatingActivity()
        if let cat = self.selectedCategory, let year = self.selectedYear {
            VoteSmartHelper.getBillsFromCategoryID(cat.categoryId, year: year) { result in
                do {
                    let bills = try result.get()
                    var tableCat = BillCategory(headerTitle: cat.name, bills: [])
                    for smart in bills.bill {
                        tableCat.bills.append(Bill(billNumber: smart.billNumber, billID: nil, type: smart.type, billURI: nil, voteSmartID: smart.billId, congressGovURL: nil, branch: nil, billTitle: smart.title, billTitleShort: nil, primarySubject: cat.name, date: nil, billSummary: "Click for details", billSummaryShort: nil, sponsorParty: nil, cosponsors: nil))
                    }
                    self.allBills = [tableCat]
                    completion(true)
                }
                catch {
                    let tableCat = BillCategory(headerTitle: cat.name, bills: [Bill(billNumber: "Empty", billID: nil, type: nil, billURI: nil, voteSmartID: nil, congressGovURL: nil, branch: nil, billTitle: "No Bills Found", billTitleShort: nil, primarySubject: "", date: nil, billSummary: "", billSummaryShort: nil, sponsorParty: nil, cosponsors: nil)])
                    self.allBills = [tableCat]
                    print("No bills")
                    completion(false)
                }
            }
        }
    }
    
    fileprivate func allVotesPopulate() {
        
        self.allBills = []
        self.startIndicatingActivity()
        ProPublicaHelper.getRecentBills("Introduced") { result in
            do {
                let bills = try result.get()
                self.allBills.append(BillCategory(headerTitle: "Introduced", bills: bills))
                ProPublicaHelper.getRecentBills("Enacted") { result in
                    do {
                        let bills = try result.get()
                        self.allBills.insert(BillCategory(headerTitle: "Enacted", bills: bills), at: 0)
                        DispatchQueue.main.async {
                            self.billTableView.reloadData()
                        }
                        self.stopIndicatingActivity()
                    } catch { print(error) }
                    
                }
            } catch { print(error) }
        }
    }
    
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
        
        if !(isCellInRange(indexPath.section, indexPath.row)) {
            return UITableViewCell()
        }
            
        let cell = tableView.dequeueReusableCell(withIdentifier: "BillTableCell") as! BillTableCell
        let bill = allBills[indexPath.section].bills[indexPath.row]
        guard bill.billNumber! != "Empty" else {
            cell.billTitleLabel.text = bill.billTitle!
            cell.shortSummaryLabel.text = "Please try a different topic or year"
            cell.billDateLabel.text = ""
            cell.billOriginLabel.text = ""
            return cell
        }
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
        
        if keyVotesSelected {
            cell.billOriginLabel.text = bill.type!
        }
        else {
            cell.billOriginLabel.text = bill.billNumber!.prefix(1) == "s" ? "Senate" : "House"
        }
        
        if let sponsorParty = bill.sponsorParty {
            if sponsorParty == "R" { cell.billOriginLabel.textColor = UIColor.red }
            else if bill.sponsorParty! == "D" { cell.billOriginLabel.textColor = UIColor.blue }
            else { cell.billOriginLabel.textColor = UIColor.black }
        } else {
            cell.billOriginLabel.textColor = UIColor.black
        }
        
        cell.billDateLabel.text = Constants.Conversions.beautifyDate(date: bill.date)
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
    
    func isCellInRange(_ section: Int, _ row: Int) -> Bool {
        if (section > allBills.count - 1) { return false }
        else if (row > allBills[section].bills.count - 1) { return false }
        return true
    }
}

extension BrowseBillsViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        
        if let searchText = searchBar.text, searchText.count > 0 {
            self.billTableView.isScrollEnabled = false
            self.allBills = []
            self.startIndicatingActivity()
            ProPublicaHelper.searchBillsFromQuery(searchText) { result in
                do {
                    let bills = try result.get()
                    self.allBills = []
                    if bills.count > 0 {
                        self.allBills.append(BillCategory(headerTitle: searchText, bills: bills))
                    } else {
                        self.allBills.append(BillCategory(headerTitle: "No Bills Found", bills: []))
                    }
                } catch { print(error) }
                DispatchQueue.main.async {
                    self.billTableView.setContentOffset(.zero, animated: true)
                    self.billTableView.reloadData()
                    self.billTableView.isScrollEnabled = true
                }
                self.stopIndicatingActivity()
            }
        } else { allVotesPopulate() }
        
        
        self.searchBar.endEditing(true)
    }
}

// MARK - Drop Down Controller
extension BrowseBillsViewController {
    
    func configureDropDowns() {
        categoryDropDown.anchorView = keyBillsButton
        categoryDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            // print("Selected item: \(item) at index: \(index)")
            self.selectedCategory = self.categories[index]
            //print(item, self.categories[index])
            self.keyVotesSelected = true
            self.keyVotesPopulate() { success in
                if success {
                    DispatchQueue.main.async {
                        self.billTableView.reloadData()
                    }
                    self.stopIndicatingActivity()
                } else {
                    // handle ui error
                    DispatchQueue.main.async {
                        self.billTableView.reloadData()
                    }
                    self.stopIndicatingActivity()
                }
            }
        }
        
        let currentYear = Calendar.current.component(.year, from: Date())
        let yearList = Array(2007...currentYear).reversed()
        let stringArray = yearList.map { String($0) }
        yearDropDown.dataSource = stringArray
        yearDropDown.anchorView = keyBillsButton
        yearDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            // print("Selected item: \(item) at index: \(index)")
            self.selectedYear = item
            self.getCategoryListForYear(item) { success in
                if success {
                    DispatchQueue.main.async {
                        self.categoryDropDown.dataSource = self.categoryNames
                        self.categoryDropDown.show()
                    }
                } else {
                    // error handle with ui
                }
            }
        }
    }
}
