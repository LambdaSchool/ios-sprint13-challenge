//
//  TabBarViewController.swift
//  Unit4-SprintChallenge1
//
//  Created by Lambda_School_Loaner_204 on 1/17/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    let entryController = EntryController()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupVCs()
    }

    private func setupVCs() {
        guard let tabViewControllers = self.viewControllers else { return }
        if let navController = tabViewControllers[0] as? UINavigationController,
            let journalTVC = navController.topViewController as? JournalTableViewController {
            journalTVC.entryController = self.entryController
        }
        if let mapVC = tabViewControllers[1] as? MapViewController {
            mapVC.entryController = self.entryController
        }
    }
}
