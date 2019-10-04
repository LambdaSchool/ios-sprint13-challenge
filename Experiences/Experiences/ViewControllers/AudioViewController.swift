//
//  AudioViewController.swift
//  Experiences
//
//  Created by Michael Redig on 10/4/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit

class AudioViewController: UIViewController {
	@IBOutlet private var recordButton: UIButton!
	@IBOutlet private var titleTextField: UITextField!
	@IBOutlet private var recordDurationLabel: UILabel!
	@IBOutlet private var previewButton: UIButton!
	@IBOutlet private var saveButton: UIBarButtonItem!

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

	var audioPlayer: AudioPlayer?

	private func updateViews() {
		recordButton.isSelected = audioRecorder.isRecording
		recordButton.isEnabled = audioPlayer?.isPlaying != true
		previewButton.isEnabled = audioPlayer != nil
		updateTimeLabel()
		saveButtonEnableLogic()
	}

	private func updateTimeLabel() {
		let minSec = timeFormatter.string(from: audioRecorder.currentTime)
		let milli = Int((audioRecorder.currentTime * 100).truncatingRemainder(dividingBy: 100))
		let milliStr = String(format: "%02i", milli)
		recordDurationLabel.text = "\(minSec ?? "").\(milliStr)"
	}

	private func saveButtonEnableLogic() {
		if audioPlayer != nil && titleTextField.text?.isEmpty == false {
			saveButton.isEnabled = true
		} else {
			saveButton.isEnabled = false
		}
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


	@IBAction func textFieldChanged(_ sender: UITextField) {
		saveButtonEnableLogic()
	}

	@IBAction func recordButton(_ sender: UIButton) {
		audioRecorder.toggleRecording()
	}

	@IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {

	}

	@IBAction func previewButtonPressed(_ sender: UIButton) {
		audioPlayer?.playPause()
	}

	// MARK: - playback setup
	private func setupPreview(playbackURL: URL) {
		audioPlayer = nil
		do {
			audioPlayer = try AudioPlayer(with: playbackURL)
			audioPlayer?.delegate = self
		} catch {
			NSLog("Error creating audio player: \(error)")
		}
	}
}

// MARK: - recording delegate
extension AudioViewController: AudioRecorderDelegate {
	func recorderDidChangeState(_ recorder: AudioRecorder) {
		updateViews()
	}

	func recorderDidFinishSavingFile(_ recorder: AudioRecorder, url: URL) {
		setupPreview(playbackURL: url)
		updateViews()
	}

	func recorderLoopUpdated(_ recorder: AudioRecorder) {
		updateTimeLabel()
	}
}

// MARK: - playback delegate
extension AudioViewController: AudioPlayerDelegate {
	func playerDidChangeState(_ player: AudioPlayer) {
		updateViews()
	}

	func playerPlaybackLoopUpdated(_ player: AudioPlayer) {}
}
