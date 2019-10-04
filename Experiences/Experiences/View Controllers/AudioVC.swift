//
//  AudioVC.swift
//  Experiences
//
//  Created by Jeffrey Santana on 10/4/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import UIKit

//protocol AudioCommentDelegate {
//	func didPostAudio(newComment: Comment?)
//}

class AudioVC: UIViewController {

	// MARK: - IBOutlets

	@IBOutlet weak var progressView: UIProgressView!
	@IBOutlet weak var elapsedTimeLabel: UILabel!
	@IBOutlet weak var durationLabel: UILabel!
	@IBOutlet weak var previewButton: UIButton!
	@IBOutlet weak var recordButton: UIButton!
	@IBOutlet weak var postButton: UIButton!
	
	// MARK: - Properties
	
	private var player: AudioPlayer?
	private var recorder = AudioRecorder()
	private lazy var timeFormatter: DateComponentsFormatter = {
		let formatting = DateComponentsFormatter()
		formatting.unitsStyle = .positional
		formatting.zeroFormattingBehavior = .pad
		formatting.allowedUnits = [.minute, .second]
		return formatting
	}()
	private var audioProgressPercentage: Float {
		guard let player = player else { return 0 }
		return Float(player.elapsedTime / player.duration) * 100
	}
	private var audioURL: URL?
	
	
	// MARK: - Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		elapsedTimeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: elapsedTimeLabel.font.pointSize,
														  weight: .regular)
		durationLabel.font = UIFont.monospacedDigitSystemFont(ofSize: durationLabel.font.pointSize,
																   weight: .regular)
		
		recorder.delegate = self
		
		#warning("Clean up file manager")
		let documentDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
		print("Doc dir: \(documentDir.path)")
		
		postButton.isEnabled = false
		updateViews()
	}
	
	// MARK: - IBActions
	
	@IBAction func previewButtonPressed(_ sender: Any) {
		player?.play()
		updateProgressBar()
	}
	
	@IBAction func recordButtonPressed(_ sender: Any) {
		recorder.toggleRecording()
	}
	
	@IBAction func postBtnTapped(_ sender: Any) {
		guard let url = audioURL,
			let audioData = try? Data(contentsOf: url) else { return }
		
		dismiss(animated: true, completion: nil)
	}
	
	@IBAction func cancelBtnTapped(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}
	
	// MARK: - Helpers
	
	private func updateViews() {
		guard let player = player else { return }
		previewButton.isEnabled = !player.isPlaying
		recordButton.tintColor = recorder.isRecording ? .gray : .red
		elapsedTimeLabel.text = timeFormatter.string(from: player.elapsedTime)
		durationLabel.text = timeFormatter.string(from: player.duration)
		
		updateProgressBar()
	}
	
	private func updateProgressBar() {
		print(audioProgressPercentage)
		progressView.setProgress(audioProgressPercentage, animated: true)
	}
}

extension AudioVC: AudioPlayerDelegate {
	func playerDidChangeState(_ player: AudioPlayer) {
		updateViews()
	}
}

extension AudioVC: AudioRecorderDelegate {
	func recorderDidChangeState(_ recorder: AudioRecorder) {
		updateViews()
	}
	
	func recorderDidFinishSavingFile(_ recorder: AudioRecorder, url: URL) {
		if !recorder.isRecording {
			do {
				player = try AudioPlayer(with: url)
				player?.delegate = self
				audioURL = url
				postButton.isEnabled = true
			} catch {
				NSLog("Could not play recording")
			}
		}
	}
}
