//
//  MapViewController.swift
//  Experiences
//
//  Created by Michael Redig on 10/4/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {
	@IBOutlet var newExperienceButton: UIButton!

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		newExperienceButton.layer.cornerRadius = 10
	}

	@IBAction func catalogNewExperienceButtonPressed(_ sender: UIButton) {
		showExperienceSelectionPrompt()
	}

	private func showExperienceSelectionPrompt() {
		let alertVC = UIAlertController(title: "Capture", message: "What would be the best way to capture this experience?", preferredStyle: .alert)

		let photoAction = UIAlertAction(title: "Photograph", style: .default) { _ in

		}
		let audioAction = UIAlertAction(title: "Audio", style: .default) { _ in

		}
		let videoAction = UIAlertAction(title: "Video", style: .default) { _ in

		}
		alertVC.addAction(photoAction)
		alertVC.addAction(audioAction)
		alertVC.addAction(videoAction)
		present(alertVC, animated: true)
	}
}

