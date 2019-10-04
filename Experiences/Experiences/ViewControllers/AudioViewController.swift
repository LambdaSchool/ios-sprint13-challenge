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
	lazy var audioRecorder: AudioRecorder = {
		let recorder = AudioRecorder()
		recorder.delegate = self
		return recorder
	}()

	private func updateViews() {
		recordButton.isSelected = audioRecorder.isRecording
		updateTimeLabel()
	}

	private func updateTimeLabel() {
		let minSec = timeFormatter.string(from: audioRecorder.currentTime)
		let milli = Int((audioRecorder.currentTime * 100).truncatingRemainder(dividingBy: 100))
		let milliStr = String(format: "%02i", milli)
		recordDurationLabel.text = "\(minSec ?? "").\(milliStr)"
	}

    override func viewDidLoad() {
        super.viewDidLoad()

		setupRecordLabel()
		updateViews()
    }

	private func setupRecordLabel() {
		let font = UIFont.monospacedDigitSystemFont(ofSize: 48, weight: .medium)
		recordDurationLabel.font = font
	}

	@IBAction func recordButton(_ sender: UIButton) {
		audioRecorder.toggleRecording()
	}

	@IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {

	}
}

extension AudioViewController: AudioRecorderDelegate {
	func recorderDidChangeState(_ recorder: AudioRecorder) {
		updateViews()
	}

	func recorderDidFinishSavingFile(_ recorder: AudioRecorder, url: URL) {
		updateViews()
	}

	func recorderLoopUpdated(_ recorder: AudioRecorder) {
		updateTimeLabel()
	}
}
