//
//  TabBarController.swift
//  ExperinceJournal
//
//  Created by Lambda_School_Loaner_218 on 2/16/20.
//  Copyright © 2020 Lambda_School_Loaner_218. All rights reserved.
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
            let journalTVC = navController.topViewController as? ExperinceTableViewController {
                    }
        if let mapVC = tabViewControllers[1] as? MapViewController {
           
        }
    }
}
