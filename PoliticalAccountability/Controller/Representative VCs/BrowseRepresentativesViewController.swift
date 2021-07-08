//
//  BrowseRepresentativesViewController.swift
//  PoliticalAccountability
//
//  Created by Van Nguyen on 11/14/20.
//  Copyright © 2020 Spencer Ho's Hose. All rights reserved.
//

import Foundation
import UIKit
import DropDown

// MARK: - BrowseRepresentativesViewController

class BrowseRepresentativesViewController: AuthorizationController {
    
    @IBOutlet weak var representativesTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var repSearchStackView: UIStackView!
    @IBOutlet weak var timePeriodButton: UIButton!
    @IBOutlet weak var partyButton: UIButton!
    @IBOutlet weak var branchButton: UIButton!
    @IBOutlet weak var viewByButton: UIButton!
    
    var currentRepresentatives: [Representative] = []
    var allRepresentatives: [Representative] = []
    var visibleRepresentatives: [RepCategory] = []
    let tableViewAccessQueue = DispatchQueue(label: "AccessQueue")
    
    let imageLoader = RepresentativeImageLoader()
    
    var repSearch = RepresentativeSearchStruct()
    let timePeriodMenu = DropDown()
    let partyMenu = DropDown()
    let branchMenu = DropDown()
    let viewByMenu = DropDown()
    
    struct RepCategory {
        var headerTitle: String
        var representatives: [Representative]
    }
    var currentRepSections: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        searchBar.delegate = self
        setTableViewProperties()
        populateRepresentativesTable()
        configureDropDownMenus()
    }
    @IBAction func timePeriodButtonPressed(_ sender: Any) {
        timePeriodMenu.show()
    }
    @IBAction func partyButtonPressed(_ sender: Any) {
        partyMenu.show()
    }
    @IBAction func branchButtonPressed(_ sender: Any) {
        branchMenu.show()
    }
    @IBAction func viewByButtonPressed(_ sender: Any) {
        viewByMenu.show()
    }
}

// MARK: - Dataworld API Controller
extension BrowseRepresentativesViewController {
    
    func getAllLegislators(completionHandler: @escaping ([Representative]?) -> Void) {
        
        if !(self.allRepresentatives.isEmpty) {
            completionHandler(allRepresentatives)
        }
        else {
            CongressIOHelper.getCongressmen(isHistorical: false, completion: { (repList) in
                if let repList = repList {
                    self.currentRepresentatives = repList
                    self.allRepresentatives.append(contentsOf: repList)
                    CongressIOHelper.getCongressmen(isHistorical: true, completion: { (repList) in
                        if let repList = repList {
                            self.allRepresentatives.append(contentsOf: repList)
                            completionHandler(self.allRepresentatives)
                        } else {
                            print("Could not get get representatives json")
                            completionHandler(nil)
                        }
                    })
                    
                } else {
                    print("Could not get get representatives json")
                    completionHandler(nil)
                }
            })
        }
    }
    
    func populateRepresentativesTable(limit: Int = 14000) {
        self.visibleRepresentatives = []
        self.currentRepSections = []
        self.startIndicatingActivity()
            
        getAllLegislators(completionHandler: { (repList) in
            if let repList = repList {
                let end = limit <= repList.count ? limit : repList.count
                self.tableViewAccessQueue.sync {
                    switch self.repSearch.viewBy {
                    case "State":
                        
                        for rep in Array(repList[..<end]) {
                            if self.doesRepConformToSearch(rep) {
                                let state = Constants.Conversions.abbreviationToStateName[rep.state!]!
                                if let index = self.currentRepSections.firstIndex(of: state), index < self.visibleRepresentatives.count {
                                    self.visibleRepresentatives[index].representatives.append(rep)
                                } else {
                                    self.currentRepSections.append(state)
                                    self.visibleRepresentatives.append(RepCategory(headerTitle: state, representatives: [rep]))
                                }
                            }
                        }
                        self.visibleRepresentatives.sort(by: {$0.headerTitle < $1.headerTitle})
                    case "Last Name":
                        for rep in Array(repList[..<end]) {
                            if self.doesRepConformToSearch(rep) {
                                let name = rep.lastName! + " " + rep.firstName!
                                let firstLetter = String(name.prefix(1))
                                if let index = self.currentRepSections.firstIndex(of: firstLetter) {
                                    self.visibleRepresentatives[index].representatives.append(rep)
                                } else {
                                    self.visibleRepresentatives.append(RepCategory(headerTitle: firstLetter, representatives: [rep]))
                                    self.currentRepSections.append(firstLetter)
                                }
                            }
                        }
                        self.visibleRepresentatives.sort(by: {$0.headerTitle < $1.headerTitle})
                    default:
                        print("This should not happen")
                    }
                    for index in 0..<self.visibleRepresentatives.count {
                        if index < self.visibleRepresentatives.count {                        self.visibleRepresentatives[index].representatives.sort(by: {$0.firstName! < $1.firstName!})
                        }
                    }
                    
                }
            }
            
            DispatchQueue.main.async {
                self.representativesTableView.reloadData()
            }
            self.stopIndicatingActivity()
        })
    }
    
    func doesRepConformToSearch(_ rep: Representative) -> Bool {
        if repSearch.timePeriod == 0 {
            if !(currentRepresentatives.contains(rep)) { return false }
        } else {
            let currentYear = Calendar.current.component(.year, from: Date())
            if ((currentYear - rep.endYear!) > repSearch.timePeriod) { return false }
        }
        if let partyAlignment = repSearch.party[rep.party!] {
            if !(partyAlignment) { return false }
        } else {
            if !(repSearch.party["Other"]!) { return false }
        }
        
        if ((rep.occupation == "sen") && !(repSearch.branch["Senate"]!)) { return false }
        if ((rep.occupation == "rep") && !(repSearch.branch["House"]!)) { return false }
        
        return true
    }
}

// MARK: - Table View Controller
extension BrowseRepresentativesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setTableViewProperties() {
        self.representativesTableView.delegate = self
        self.representativesTableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return visibleRepresentatives.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (!isCellInRange(section, -1)) {
            return 0
        }
        return visibleRepresentatives[section].representatives.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (!isCellInRange(section, -1)) {
            return ""
        }
        return visibleRepresentatives[section].headerTitle
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // print(indexPath.section, indexPath.row)
        if !(isCellInRange(indexPath.section, indexPath.row)) {
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepCell") as! RepresentativeTableCell
        let rep = visibleRepresentatives[indexPath.section].representatives[indexPath.row]
        // print(rep)
        cell.name.text = rep.firstName! + " " + rep.lastName!
        cell.occupation.text = Constants.Conversions.abbreviationToOccupationName[rep.occupation!]
        if let state = Constants.Conversions.abbreviationToStateName[rep.state!], let district = rep.district {
            cell.location.text = state + ((district != -1) ? ", District " + String(district) : "")
        } else { print(rep)}
        cell.party.text = rep.party!
        
        let token = imageLoader.loadImage(bioguideID: rep.bioguideID!, completion: { result in
            do {
                let image = try result.get()
                
                DispatchQueue.main.async {
                    cell.repImageView.image = image
                }
            } catch {
                if error.localizedDescription != "cancelled" {
                    print(error.localizedDescription)
                }
            }
        })
        
        cell.onReuse = {
            if let token = token {
                self.imageLoader.cancelLoad(token)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let representative = visibleRepresentatives[indexPath.section].representatives[indexPath.row]

        let representativeDetailVC = self.storyboard?.instantiateViewController(identifier: "MenuRepresentativeViewController") as! MenuRepresentativeViewController
        representativeDetailVC.representative = representative
        navigationController?.pushViewController(representativeDetailVC, animated: true)
    }
    
    func isCellInRange(_ section: Int, _ row: Int) -> Bool {
        if (section > visibleRepresentatives.count - 1) { return false }
        else if (row > visibleRepresentatives[section].representatives.count - 1) { return false }
        return true
    }
}

// MARK: - UISearchBar Delegate
extension BrowseRepresentativesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            populateRepresentativesTable()
            return
        }
        self.tableViewAccessQueue.sync {
            self.visibleRepresentatives = [RepCategory(headerTitle: searchText, representatives: [])]
            var query = searchText.lowercased().split(separator: " ")
            if query.count > 2 {
                query = Array(query[0..<2])
            }
            for rep in self.allRepresentatives {
                var valid = true
                let name = (rep.firstName! + rep.lastName!).lowercased()
                for q in query {
                    if !name.contains(q) {
                        valid = false
                        break
                    }
                }
                if (valid) {
                    self.visibleRepresentatives[0].representatives.append(rep)
                }
            }
        }
        representativesTableView.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
}

// MARK: - Drop Down View Handler
extension BrowseRepresentativesViewController {
    fileprivate func configureDropDownMenus() {
        
        timePeriodMenu.dataSource = [
            "Current",
            "10 years",
            "50 years",
            "100 years",
            "All"
        ]
        timePeriodMenu.anchorView = repSearchStackView
        timePeriodMenu.selectionAction = { [unowned self] (index: Int, item: String) in
            // print("Selected item: \(item) at index: \(index)")
            self.repSearch.timePeriod = Constants.Conversions.timePeriodLabelToInt[item]!
            self.timePeriodButton.setTitle(item, for: .normal)
            self.populateRepresentativesTable()
        }
        
        
        partyMenu.dataSource = [
            "All Parties",
            "Democrat",
            "Republican",
            "Other",
        ]
        partyMenu.anchorView = repSearchStackView
        partyMenu.selectionAction = { [unowned self] (index: Int, item: String) in
            // print("Selected item: \(item) at index: \(index)")
            if item == "All Parties" {
                for key in self.repSearch.party.keys {
                    self.repSearch.party.updateValue(true, forKey: key)
                }
            } else {
                for key in self.repSearch.party.keys {
                    self.repSearch.party.updateValue(false, forKey: key)
                }
                self.repSearch.party.updateValue(true, forKey: item)
            }
            self.partyButton.setTitle(item, for: .normal)
            self.populateRepresentativesTable()
        }
        
        
        branchMenu.dataSource = [
            "Both",
            "Senate",
            "House"
        ]
        branchMenu.anchorView = repSearchStackView
        branchMenu.selectionAction = { [unowned self] (index: Int, item: String) in
            // print("Selected item: \(item) at index: \(index)")
            if item == "Both" {
                for key in self.repSearch.branch.keys {
                    self.repSearch.branch.updateValue(true, forKey: key)
                }
            }
            else {
                for key in self.repSearch.branch.keys {
                    self.repSearch.branch.updateValue(false, forKey: key)
                }
                self.repSearch.branch.updateValue(true, forKey: item)
            }
            self.branchButton.setTitle(item, for: .normal)
            self.populateRepresentativesTable()
        }
        
        
        viewByMenu.dataSource = [
            "State",
            "Last Name",
        ]
        viewByMenu.anchorView = repSearchStackView
        viewByMenu.selectionAction = { [unowned self] (index: Int, item: String) in
            // print("Selected item: \(item) at index: \(index)")
            self.repSearch.viewBy = item
            self.viewByButton.setTitle(item, for: .normal)
            self.populateRepresentativesTable()
        }

    }
}
