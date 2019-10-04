//
//  VideoRecordingViewController.swift
//  LambdaTimeline
//
//  Created by Michael Redig on 10/2/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import AVFoundation

class VideoRecordingViewController: UIViewController, ExperienceControllerAccessor {
	/// hide this when video is recording - makes it really hard to accidentally NOT record
	@IBOutlet private var indicatorContainer: UIView!
	@IBOutlet private var recordButton: UIButton!
	@IBOutlet private var playbackButton: UIButton!
	@IBOutlet private var cameraPreviewView: CameraPreviewView!
	@IBOutlet private var videoPreviewView: VideoPlayerView!
	@IBOutlet private var titleTextField: UITextField!

	var experienceController: ExperienceController?
	var videoHelper: VideoSessionManager?
	private var lastRecording: URL? {
		didSet {
			setupPlayback()
		}
	}

	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()

		recordButton.tintColor = .systemRed
		playbackButton.tintColor = .systemGreen

		checkCameraPermission()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		videoHelper?.startRunning()
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		videoHelper?.stopRunning()
	}

	private func updateViews() {
		indicatorContainer.isHidden = videoHelper?.isRecording ?? false

		playbackButton.isEnabled = lastRecording != nil

		recordButton.isHidden = videoPreviewView.isPlaying
		recordButton.isSelected = videoHelper?.isRecording ?? false
		videoPreviewView.isHidden = !videoPreviewView.isPlaying
	}

	private func setupCamera() {
		do {
			videoHelper = try VideoSessionManager()
			videoHelper?.delegate = self
			cameraPreviewView.session = videoHelper?.captureSession
			videoHelper?.startRunning()
		} catch {
			NSLog("Error creating camera helper: \(error)")
		}
	}

	// MARK: - Privacy/camera permission
	private func checkCameraPermission() {
		let status = AVCaptureDevice.authorizationStatus(for: .video)

		switch status {
		case .notDetermined:
			requestCameraPermission()
		case .authorized:
			setupCamera()
		default:
			// show error saying to check permissions
			showPermissionError()
		}
	}

	private func requestCameraPermission() {
		AVCaptureDevice.requestAccess(for: .video) { granted in
			if granted == false {
				DispatchQueue.main.async {
					self.showPermissionError()
				}
			} else {
				DispatchQueue.main.async {
					self.setupCamera()
				}
			}
		}
	}

	private func showPermissionError() {
		let alertVC = UIAlertController(title: "Permissions Error",
										message: "Access to the camera has not been granted. Please check the Settings app to allow camera access.",
										preferredStyle: .alert)
		let okay = UIAlertAction(title: "Okie Dokey", style: .default)
		alertVC.addAction(okay)
		present(alertVC, animated: true)
	}

	// MARK: - IBActions
	@IBAction func recordButtonUp(_ sender: UIButton) {
		videoHelper?.recordToggle()
	}

	@IBAction func playButtonPressed(_ sender: UIButton) {
		videoPreviewView.playStopToggle()
	}

	@IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
	}


	// MARK: - Playback
	private func setupPlayback() {
		if let lastRecording = lastRecording {
			videoPreviewView.delegate = self
			videoPreviewView.loadMovie(url: lastRecording)
		}
	}

}

extension VideoRecordingViewController: VideoSessionManagerDelegate {
	func videoSessionManager(_ manager: VideoSessionManager, didStartCaptureSession running: Bool) {
		if running {
			NSLog("Started video capture session")
		} else {
			NSLog("Stopped video capture session")
		}
		updateViews()
	}

	func videoSessionManager(_ manager: VideoSessionManager, didStartRecordingToURL url: URL) {
		NSLog("Started recording to \(url)")
		DispatchQueue.main.async {
			self.updateViews()
		}
	}

	func videoSessionManager(_ manager: VideoSessionManager, didFinishRecordingToURL url: URL, error: Error?) {
		NSLog("Finished recording to \(url)")
		DispatchQueue.main.async {
			// load player from url here
			self.lastRecording = url
			self.updateViews()
		}
	}
}

extension VideoRecordingViewController: VideoPlayerViewDelegate {
	func videoPlayerViewStatusChanged(_ videoPlayerView: VideoPlayerView) {
		updateViews()
	}
}
