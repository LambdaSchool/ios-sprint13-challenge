//
//  ExperienceTabBarController.swift
//  Experiences
//
//  Created by Michael Redig on 10/4/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit

class ExperienceTabBarController: UITabBarController {
	let experienceController = ExperienceController()

    override func viewDidLoad() {
        super.viewDidLoad()

		for vc in children {
			if let experienceAccessor = vc as? ExperienceControllerAccessor {
				experienceAccessor.experienceController = experienceController
			}
		}
    }
}
