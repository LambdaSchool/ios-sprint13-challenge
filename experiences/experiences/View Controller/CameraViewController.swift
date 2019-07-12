//
//  CameraViewController.swift
//  experiences
//
//  Created by Hector Steven on 7/12/19.
//  Copyright © 2019 Hector Steven. All rights reserved.
//

import UIKit

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
	
	var experienceController: ExperienceController?
	var fileTitle: String?
	
	var audioRecorder: Recorder?
	
	
	lazy private var captureSession = AVCaptureSession()
	lazy private var fileOutput = AVCaptureMovieFileOutput()
	
	private var player: AVPlayer!
	
	@IBOutlet var recordButton: UIButton!
	
	@IBOutlet var cameraView: CameraPreviewView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		cameraSetup()
		
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		captureSession.startRunning()
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		captureSession.stopRunning()
	}
	
	@IBAction func recordButtonPressed(_ sender: Any) {
		guard let fileTitle = fileTitle else {
			NSLog("title not set")
			return
		}
		
		if fileOutput.isRecording {
			fileOutput.stopRecording()
		} else {
			audioRecorder = Recorder()
			audioRecorder?.startRecord(with: fileTitle)
			fileOutput.startRecording(to: newRecordingURL(fileTitle: fileTitle), recordingDelegate: self)
		}
	}
	
	func newRecordingURL(fileTitle: String) -> URL {
		let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
		let url = documentsDirectory.appendingPathComponent(fileTitle).appendingPathExtension("mov")
		return url
	}
	
	

	private func cameraSetup() {
		let camera = bestCamera()
		
		guard let cameraInput = try? AVCaptureDeviceInput(device: camera) else {
			fatalError("Can't create input from camera")
		}
		
		// Setup inputs
		if captureSession.canAddInput(cameraInput) {
			captureSession.addInput(cameraInput)
		}
		
		
		// Setup outputs
		if captureSession.canAddOutput(fileOutput) {
			captureSession.addOutput(fileOutput)
		}
		
		if captureSession.canSetSessionPreset(.hd1920x1080) {
			captureSession.canSetSessionPreset(.hd1920x1080)
		}
		
		captureSession.commitConfiguration()
		
		cameraView.session = captureSession
		
//		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
//		view.addGestureRecognizer(tapGesture)
	}
//
//	@objc func handleTapGesture(_ tapGesture: UITapGestureRecognizer) {
//		// play the movie
//		print("Play movie")
//		if let player = player {
//			player.seek(to: CMTime.zero)
//			player.play()
//		}
//
//	}
	
	private func bestCamera() -> AVCaptureDevice {
		if let device = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) {
			return device
		}
		
		if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
			return device
		}
		
		fatalError("No cameras exist - you're probably running on the simulator")
	}
	
	
	
	func updateViews() {
		if fileOutput.isRecording {
			recordButton.setImage(UIImage(named: "Stop"), for: .normal)
			recordButton.tintColor = UIColor.black
		} else {
			recordButton.setImage(UIImage(named: "Record"), for: .normal)
			recordButton.tintColor = UIColor.red
		}
	}
}

extension CameraViewController: AVCaptureFileOutputRecordingDelegate {
	func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
		
		DispatchQueue.main.async {
			self.updateViews()
		}
	}
	
	func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
		guard let currentLoaction = experienceController?.currentLocation, let fileTitle = fileTitle else {
			NSLog("fileTitle and CurrentLocation Not set")
			return
		}
		let experience = Experience(title: fileTitle, coordinate: currentLoaction)
		experience.video = String(outputFileURL.absoluteString)
		experienceController?.addExperience(experience: experience)
		
		dismiss(animated: true, completion: nil)
	}
}




