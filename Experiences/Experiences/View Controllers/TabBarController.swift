//
//  TabBarController.swift
//  Experiences
//
//
//  Created by Rick Wolter on 2/14/20.
//  Copyright © 2020 Devshop7. All rights reserved.
//


import UIKit

class TabBarController: UITabBarController {
    
    let experienceController = ExperienceController()

    override func viewDidLoad() {
        super.viewDidLoad()

        for viewController in viewControllers ?? [] {
            if let navigationVC = viewController as? UINavigationController {
                for viewController in navigationVC.viewControllers {
                    if let postsVC = viewController as? ExperiencesTableViewController {
                        postsVC.experienceController = experienceController
                    }
                }
            } else if let mapVC = viewController as? MapViewController {
                mapVC.experienceController = experienceController
            }
        }
    }

}
