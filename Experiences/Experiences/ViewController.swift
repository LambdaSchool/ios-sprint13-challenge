//
//  ViewController.swift
//  Experiences
//
//  Created by Michael Redig on 10/4/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	@IBOutlet var newExperienceButton: UIButton!

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		newExperienceButton.layer.cornerRadius = 10
	}

	@IBAction func catalogNewExperienceButtonPressed(_ sender: UIButton) {
	}
	
}

