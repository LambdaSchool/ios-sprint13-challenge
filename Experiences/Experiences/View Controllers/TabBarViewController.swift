//
//  TabBarViewController.swift
//  Experiences
//
//  Created by Sal B Amer on 5/19/20.
//  Copyright © 2020 Sal B Amer. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    let experienceController = ExperienceController()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupVCs()
    }

    private func setupVCs() {
        guard let tabViewControllers = self.viewControllers else { return }
        if let navController = tabViewControllers[0] as? UINavigationController,
            let journalTVC = navController.topViewController as? ExperiencesTableViewController {
            journalTVC.experienceController = self.experienceController
        }
        if let mapVC = tabViewControllers[1] as? MapViewController {
            mapVC.experienceController = self.experienceController
        }
    }
}
