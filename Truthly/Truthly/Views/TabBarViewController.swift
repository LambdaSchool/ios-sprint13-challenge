//
//  TabBarViewController.swift
//  Truthly
//
//  Created by Ezra Black on 6/7/20.
//  Copyright © 2020 Casanova Studios. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    let postController = PostController()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        // Do any additional setup after loading the view.
    }
  private func setupViews() {
        guard let tabViewControllers = self.viewControllers else { return }
        if let navController = tabViewControllers[0] as? UINavigationController,
            let postTVC = navController.topViewController as? TableViewController {
            postTVC.postController = self.postController
        }
        if let mapView = tabViewControllers[1] as? MapViewController {
            mapView.postController = self.postController
        }
    }
}
