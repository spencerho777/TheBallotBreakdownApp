//
//  BillHighlightsViewController.swift
//  PoliticalAccountability
//
//  Created by Van Nguyen on 6/13/21.
//  Copyright © 2021 Spencer Ho's Hose. All rights reserved.
//

import Foundation
import UIKit

class BillHighlightsViewController: UIViewController {
    
    // Injection
    var highlights: String?
    var isSmartBill: Bool?
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.isSmartBill! {
            if let highlights = self.highlights {
                self.textView.attributedText = highlights.htmlToAttributedString
            } else {
                self.textView.text = "A longer summary for this bill has not yet been written"
            }
        } else {
            self.textView.font = .systemFont(ofSize: 20)
            self.textView.text = highlights
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.setContentOffset(.zero, animated: true)
    }
}
