//
//  ExperiencesTabBarController.swift
//  Experiences
//
//  Created by Chad Rutherford on 2/14/20.
//  Copyright © 2020 Chad Rutherford. All rights reserved.
//

import UIKit

class ExperiencesTabBarController: UITabBarController {
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = .systemTeal
        viewControllers = [createDocumentTableViewController(), createExperiencesMapViewController()]
    }
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - View Controller Configuration
    func createDocumentTableViewController() -> UINavigationController {
        let documentsTableVC = DocumentsTableViewController(nibName: nil, bundle: nil)
        documentsTableVC.title = "Experiences"
        documentsTableVC.tabBarItem = UITabBarItem(title: "Documents", image: UIImage(systemName: "folder"), tag: 0)
        return UINavigationController(rootViewController: documentsTableVC)
    }
    
    func createExperiencesMapViewController() -> UINavigationController {
        let experiencesMapVC = ExperiencesMapViewController()
        experiencesMapVC.title = "Experience Locations"
        experiencesMapVC.tabBarItem = UITabBarItem(title: "Experiences", image: UIImage(systemName: "map"), tag: 1)
        return UINavigationController(rootViewController: experiencesMapVC)
    }
}
