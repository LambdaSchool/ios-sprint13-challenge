//
//  ControllerDistributorViewController.swift
//  Experiences
//
//  Created by Michael Redig on 10/4/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit

class ControllerDistributorViewController: UINavigationController {
	let experienceController = ExperienceController()

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
    }
}

extension ControllerDistributorViewController: UINavigationControllerDelegate {
	func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
		if let experienceAccessor = viewController as? ExperienceControllerAccessor {
			experienceAccessor.experienceController = experienceController
		}
	}
}
