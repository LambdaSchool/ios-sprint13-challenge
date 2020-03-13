//
//  TabBarController.swift
//  Experiences-Xcode
//
//  Created by Austin Potts on 3/13/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import MapKit

class TabBarController: UITabBarController {

    let experienceController = ExperienceController()

     override func viewDidLoad() {
         super.viewDidLoad()

         for viewController in viewControllers ?? [] {
             if let navigationVC = viewController as? UINavigationController {
                 for viewController in navigationVC.viewControllers {
                     if let postsVC = viewController as? ExperienceListTableViewController {
                         postsVC.experienceController = experienceController
                     }
                 }
             } else if let mapVC = viewController as? MapViewController {
                 mapVC.experienceController = experienceController
             }
         }
     }

}
