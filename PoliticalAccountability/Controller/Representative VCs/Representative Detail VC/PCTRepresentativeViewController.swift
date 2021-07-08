//
//  PCTRepresentativeViewController.swift
//  PoliticalAccountability
//
//  Created by Van Nguyen on 1/18/21.
//  Copyright © 2021 Spencer Ho's Hose. All rights reserved.
//

import Foundation
import UIKit

class PCTRepresentativeViewController: CollapsibleTableSectionViewController {
    
    // injection
    var representative: Representative?
    
    var sections: [PCTIssue] = []
    var surveyMessage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        let nib = UINib.init(nibName: "PCTCell", bundle: nil)
        self._tableView.register(nib, forCellReuseIdentifier: "PCTCell")
        print(representative!.voteSmartID)
        if let votesmartID = representative?.voteSmartID {
            let candidateID: String = String(votesmartID)
            print(candidateID)
            VoteSmartHelper.getPCTFromCandidateID(candidateID) { result in
                do {
                    let PCT = try result.get()
                    //if
                    for var s in PCT.section {
                        var validRows: [PCTResponse] = []
                        for r in s.row {
                            if r.answerText != "" || r.optionText != "" {
                                validRows.append(r)
                            }
                        }
                        s.row = validRows
                        self.sections.append(s)
                    }
                } catch {
                    print(error)
                }
                DispatchQueue.main.async {
                    self._tableView.reloadData()
                }
            }
        }
    }
}
extension PCTRepresentativeViewController: CollapsibleTableSectionDelegate {
    func numberOfSections(_ tableView: UITableView) -> Int {
        return sections.count
    }
    
    func collapsibleTableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].row.count
    }
    
    func collapsibleTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: PCTCell = tableView.dequeueReusableCell(withIdentifier: "PCTCell") as! PCTCell
        let row: PCTResponse = sections[indexPath.section].row[indexPath.row]
        
        cell.questionLabel.text = row.rowText
        if row.optionText != "" {
            cell.answerLabel.text = row.optionText
        } else {
            cell.answerLabel.text = row.answerText
        }
        
        return cell
    }
    
    func collapsibleTableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 100.0
    }
    
    func collapsibleTableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].name
    }
    func shouldCollapseByDefault(_ tableView: UITableView) -> Bool {
        return true
    }
}
