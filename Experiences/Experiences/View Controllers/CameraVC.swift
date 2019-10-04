//
//  CameraVC.swift
//  Experiences
//
//  Created by Jeffrey Santana on 10/4/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import UIKit
import AVFoundation

class CameraVC: UIViewController {

	// MARK: - IBOutlets
	
    @IBOutlet var cameraView: CameraPreviewView!
	@IBOutlet var recordButton: UIButton!
	@IBOutlet weak var deleteBtn: UIButton!
	@IBOutlet weak var postBtn: UIButton!
	
	// MARK: - Properties
	
	lazy private var captureSession = AVCaptureSession()
	lazy private var fileOutput = AVCaptureMovieFileOutput()
	private var player: AVPlayer?
	private var videoUrl: URL?
	private var playerLayer: AVPlayerLayer?
	
	// MARK: - Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupCamera()
		toggleButtons()
		
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
		view.addGestureRecognizer(tapGesture)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		print("Started Running")
		captureSession.startRunning()
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		
		print("Stopped Running")
		captureSession.stopRunning()
	}
	
	// MARK: - IBActions
	
	@IBAction func deleteBtnTapped(_ sender: Any) {
		player = nil
		playerLayer?.removeFromSuperlayer()
		toggleButtons()
	}
	
	@IBAction func postBtnTapped(_ sender: Any) {
		let alert = UIAlertController(title: nil, message: "Enter a description", preferredStyle: .alert)
		alert.addTextField(configurationHandler: nil)
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		let postAction = UIAlertAction(title: "Post", style: .default) { (_) in
			guard let description = alert.textFields?.first?.text, description != "" else { return }
			guard let url = self.videoUrl,
			let videoData = try? Data(contentsOf: url) else { return }
			
		}
		
		[cancelAction, postAction].forEach({ alert.addAction($0) })
		present(alert, animated: true, completion: nil)
	}
	
	@IBAction func recordButtonPressed(_ sender: Any) {
		record()
	}
	
	// MARK: - Helpers
	
	@objc private func handleTapGesture(_ tapGesture: UITapGestureRecognizer) {
		switch tapGesture.state {
		case .began:
			print("Tapped")
		case .ended:
			replayRecording()
		default:
			print("Handle gesture state: \(tapGesture.state)")
		}
	}
	
	private func bestCamera() -> AVCaptureDevice {
		if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
			return device
		} else {
			fatalError("No cameras on the device/simulator")
		}
	}

	private func setupCamera() {
		let camera = bestCamera()
		guard let cameraInput = try? AVCaptureDeviceInput(device: camera) else {
			fatalError("Cant create an input from this camera device")
		}
		
		//Input
		guard captureSession.canAddInput(cameraInput) else {
			fatalError("This session cant handle this type of input")
		}
		
		captureSession.addInput(cameraInput)
		
		if captureSession.canSetSessionPreset(.hd1920x1080) {
			captureSession.sessionPreset = .hd1920x1080
		}
		
		let microphone = audio()
		guard let audioInput = try? AVCaptureDeviceInput(device: microphone) else {
			fatalError("Can't create input from microphone")
		}
		guard captureSession.canAddInput(audioInput) else {
			fatalError("Can't add audio input")
		}
		captureSession.addInput(audioInput)
		
		//Output
		guard captureSession.canAddOutput(fileOutput) else {
            fatalError("Cannot record to a movie file")
        }
        captureSession.addOutput(fileOutput)
		
		captureSession.commitConfiguration()
		cameraView.session = captureSession
	}
	
	private func audio() -> AVCaptureDevice {
		if let device = AVCaptureDevice.default(for: .audio) {
			return device
		}
		
		fatalError("No audio detected")
	}
	
	private func newTempURL(withFileExtension fileExtension: String? = nil) -> URL {
		let tempDir = URL(fileURLWithPath: NSTemporaryDirectory())
		let name = UUID().uuidString
		let tempFile = tempDir.appendingPathComponent(name).appendingPathExtension(fileExtension ?? "")

		return tempFile
	}
	
	private func record() {
		if fileOutput.isRecording {
			fileOutput.stopRecording()
		} else {
			fileOutput.startRecording(to: newTempURL(withFileExtension: "mov"), recordingDelegate: self)
		}
	}
	
	private func replayRecording() {
		if let player = player {
			player.seek(to: CMTime.zero)
			player.play()
		}
	}
	
	private func updateViews() {
		recordButton.isSelected = fileOutput.isRecording
		recordButton.tintColor = recordButton.isSelected ? .black : .red
	}
	
	private func toggleButtons() {
		if player != nil {
			recordButton.isHidden = true
			[deleteBtn, postBtn].forEach({ $0.isHidden = false })
		} else {
			recordButton.isHidden = false
			[deleteBtn, postBtn].forEach({ $0.isHidden = true })
		}
	}
	
	private func playVideo(from url: URL) {
		player = AVPlayer(url: url)
		
		let playerLayer = AVPlayerLayer(player: player)

		playerLayer.frame = cameraView.frame
		view.layer.insertSublayer(playerLayer, above: cameraView.layer)
		self.playerLayer = playerLayer
		
		player?.play()
		toggleButtons()
	}
}

extension CameraVC: AVCaptureFileOutputRecordingDelegate {
	func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
		DispatchQueue.main.async {
			self.updateViews()
        }
	}
	
	func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
		DispatchQueue.main.async {
			self.videoUrl = outputFileURL
			self.updateViews()
			self.playVideo(from: outputFileURL)
        }
	}
}

