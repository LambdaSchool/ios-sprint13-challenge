//
//  NavigationController.swift
//  Experiences
//
//  Created by Jason Modisett on 1/18/19.
//  Copyright © 2019 Jason Modisett. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // Setup method
    private func setup() {
        navigationBar.prefersLargeTitles = true
        
        navigationBar.shadowImage = UIImage()
        
        navigationBar.layer.shadowRadius = 14
        navigationBar.layer.shadowOpacity = 0.4
    }
    
}
