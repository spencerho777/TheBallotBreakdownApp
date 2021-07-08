//
//  MenuRepresentativeDetailViewController.swift
//  PoliticalAccountability
//
//  Created by Van Nguyen on 12/6/20.
//  Copyright © 2020 Spencer Ho's Hose. All rights reserved.
//

import Foundation
import UIKit
import Swift_PageMenu

class MenuRepresentativeViewController: PageMenuController {
    
    var representative: Representative?
    
    var controllers: [UIViewController] = []

    var titles: [String] = []
    var currentView: UIViewController?

//    init(items: [[String]], titles: [String], options: PageMenuOptions? = nil) {
//        self.items = items
//        self.titles = titles
//        super.init(options: options)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpPageMenu()
    }
    
    fileprivate func setUpPageMenu() {
        self.edgesForExtendedLayout = []
        
        if options.layout == .layoutGuide && options.tabMenuPosition == .bottom {
            self.view.backgroundColor = UIColor(red: 3/255, green: 125/255, blue: 233/255, alpha: 1)
        } else {
            self.view.backgroundColor = .white
        }
        
        if self.options.tabMenuPosition == .custom {
            self.view.addSubview(self.tabMenuView)
            self.tabMenuView.translatesAutoresizingMaskIntoConstraints = false
            
            self.tabMenuView.heightAnchor.constraint(equalToConstant: self.options.menuItemSize.height).isActive = true
            self.tabMenuView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
            self.tabMenuView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
            if #available(iOS 11.0, *) {
                self.tabMenuView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            } else {
                self.tabMenuView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
            }
        }
        
        let bioVC = self.storyboard?.instantiateViewController(identifier: "LifeRepresentativeViewController") as! LifeRepresentativeViewController
        bioVC.representative = self.representative
        bioVC.parentView = self
        self.controllers.append(bioVC)
        self.titles.append("Biography")
        
        let sponsorVC = self.storyboard?.instantiateViewController(identifier: "SponsorRepresentativeViewController") as! SponsorRepresentativeViewController
        sponsorVC.representative = self.representative
        sponsorVC.parentView = self
        self.controllers.append(sponsorVC)
        self.titles.append("Sponsored Bills")
        
//        let PCTVC = self.storyboard?.instantiateViewController(identifier: "PCTRepresentativeViewController") as! PCTRepresentativeViewController
//        PCTVC.representative = self.representative
//        self.controllers.append(PCTVC)
//        self.titles.append("Issue Positions")
        
        let voteVC = self.storyboard?.instantiateViewController(identifier: "VoteRepresentativeViewController") as! VoteRepresentativeViewController
        voteVC.representative = self.representative
        voteVC.parentView = self
        self.controllers.append(voteVC)
        self.titles.append("Votes")
        
        self.currentView = bioVC
        self.delegate = self
        self.dataSource = self
    }
    
    func stopActivityIfOnMe(_ controller: UIViewController) {
        if controller == currentView {
            self.stopIndicatingActivity()
        }
    }
}

extension MenuRepresentativeViewController: PageMenuControllerDataSource {
    func viewControllers(forPageMenuController pageMenuController: PageMenuController) -> [UIViewController] {
        return self.controllers
    }

    func menuTitles(forPageMenuController pageMenuController: PageMenuController) -> [String] {
        return self.titles
    }

    func defaultPageIndex(forPageMenuController pageMenuController: PageMenuController) -> Int {
        return 0
    }
}

extension MenuRepresentativeViewController: PageMenuControllerDelegate {
    func pageMenuController(_ pageMenuController: PageMenuController, didScrollToPageAtIndex index: Int, direction: PageMenuNavigationDirection) {
        // The page view controller will begin scrolling to a new page.
        self.currentView = controllers[index]
        if (self.controllers[index] as! RepresentativeDetailViewController).inProgress {
            self.startIndicatingActivity()
        } else {
            self.stopIndicatingActivity()
        }
    }
//
//    func pageMenuController(_ pageMenuController: PageMenuController, willScrollToPageAtIndex index: Int, direction: PageMenuNavigationDirection) {
//        // The page view controller scroll progress between pages.
//        print("willScrollToPageAtIndex index:\(index)")
//    }
//
//    func pageMenuController(_ pageMenuController: PageMenuController, scrollingProgress progress: CGFloat, direction: PageMenuNavigationDirection) {
//        // The page view controller did complete scroll to a new page.
//    }
//
//    func pageMenuController(_ pageMenuController: PageMenuController, didSelectMenuItem index: Int, direction: PageMenuNavigationDirection) {
//        print("didSelectMenuItem index: \(index)")
//    }
}
