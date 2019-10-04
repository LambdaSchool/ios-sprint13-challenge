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

	private lazy var timeFormatter: DateComponentsFormatter = {
		let formatting = DateComponentsFormatter()
		formatting.unitsStyle = .positional // 00:00
		formatting.zeroFormattingBehavior = .pad
		formatting.allowedUnits = [.minute, .second]
		return formatting
	}()

    override func viewDidLoad() {
        super.viewDidLoad()

		setupRecordLabel()
    }

	private func setupRecordLabel() {
		let font = UIFont.monospacedDigitSystemFont(ofSize: 48, weight: .medium)
		recordDurationLabel.font = font
	}

	@IBAction func recordButton(_ sender: UIButton) {
	}

	@IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {

	}
}
