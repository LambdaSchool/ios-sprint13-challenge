//
//  TabBarController.swift
//  Experiences
//
//  Created by Isaac Lyons on 12/6/19.
//  Copyright © 2019 Lambda School. All rights reserved.
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
