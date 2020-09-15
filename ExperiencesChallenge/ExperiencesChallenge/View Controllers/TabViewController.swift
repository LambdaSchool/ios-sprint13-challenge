//
//  TabViewController.swift
//  ExperiencesChallenge
//
//  Created by Ian French on 9/13/20.
//  Copyright © 2020 Ian French. All rights reserved.
//

import UIKit

class TabViewController: UITabBarController {

    let experienceController = ExperienceController()

        override func viewDidLoad() {
            super.viewDidLoad()
            setupVCs()
        }

        private func setupVCs() {
            guard let tabViewControllers = self.viewControllers else { return }
            if let navController = tabViewControllers[0] as? UINavigationController,
                let experienceTVC = navController.topViewController as? ExperienceTableViewController {
                experienceTVC.experienceController = self.experienceController
            }
            if let mapVC = tabViewControllers[1] as? MapViewController {
                mapVC.experienceController = self.experienceController

        }
    }
}
