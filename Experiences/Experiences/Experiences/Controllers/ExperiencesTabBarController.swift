//
//  ExperiencesTabBarController.swift
//  Experiences
//
//  Created by Joe on 5/23/20.
//  Copyright © 2020 AlphaGradeINC. All rights reserved.
//

import UIKit

class ExperiencesTabBarController: UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = .systemTeal
        viewControllers = [createDocumentTableViewController(), createExperiencesMapViewController()]
    }
    
    func createDocumentTableViewController() -> UINavigationController {
        let documentsTableVC = DocumentsTableViewController(nibName: nil, bundle: nil)
        documentsTableVC.title = "Experiences"
        documentsTableVC.tabBarItem = UITabBarItem(title: "Documents", image: UIImage(systemName: "folder"), tag: 0)
        return UINavigationController(rootViewController: documentsTableVC)
    }
    func createExperiencesMapViewController() -> UINavigationController {
        let experiencesMapVC = ExperiencesMapViewController()
        experiencesMapVC.title = "Experience locations"
        experiencesMapVC.tabBarItem = UITabBarItem(title: "Experiences", image: UIImage(systemName: "map"), tag: 1)
        return UINavigationController(rootViewController: experiencesMapVC)
    }

}
