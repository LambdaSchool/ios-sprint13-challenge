//
//  AudioViewController.swift
//  Experiences
//
//  Created by Michael Redig on 10/4/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit

class AudioViewController: UIViewController {
	@IBOutlet var recordButton: UIButton!
	@IBOutlet var titleTextField: UITextField!
	@IBOutlet var recordDurationLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

		setupRecordLabel()
    }

	private func setupRecordLabel() {
		let font = UIFont.monospacedDigitSystemFont(ofSize: 48, weight: .medium)
		recordDurationLabel.font = font
	}

	@IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
	}
}
