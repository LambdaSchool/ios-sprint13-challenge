//
//  CameraViewController.swift
//  VideoRecorder
//
//  Created by Paul Solt on 10/2/19.
//  Copyright © 2019 Lambda, Inc. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    
    lazy private var captureSession = AVCaptureSession()
    lazy private var fileOutput = AVCaptureMovieFileOutput()
    private var player: AVPlayer! // we promise to set it out before using it ... or it'll crash!
    
    
    @IBAction func nextButton(_ sender: Any) {
        performSegue(withIdentifier: "cameraToAudio", sender: (Any).self)
    }
    
    @IBOutlet var recordButton: UIButton!
    @IBOutlet var cameraView: CameraPreviewView!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let _ = segue.destination as? AudioRecorderController
    }

	override func viewDidLoad() {
		super.viewDidLoad()

		// Resize csamera preview to fill the entire screen
		cameraView.videoPlayerView.videoGravity = .resizeAspectFill
        
        performSegue(withIdentifier: "cameraToAudio", sender: self)

        setUpCaptureSession()
	}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        captureSession.startRunning()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        captureSession.commitConfiguration()
        cameraView.session = captureSession
    }

    private func updateViews() {
        recordButton.isSelected = fileOutput.isRecording
    }

    
    private func toggleRecord() {
        if fileOutput.isRecording {
            fileOutput.stopRecording()
        } else {
            fileOutput.startRecording(to: newRecordingURL(), recordingDelegate: self)
        }
    }
    
    // MARK: - DON'T HAVE A WORKING iOS DEVICE. UNCOMMENT CODE TO SEE IF IT WORKS.
    private func setUpCaptureSession() {
        // Add inputs
        captureSession.beginConfiguration()
        // Camera Input
        let camera = bestCamera()
        
        // Microphone Input
        guard let cameraInput = try? AVCaptureDeviceInput(device: camera), captureSession.canAddInput(cameraInput) else {
            fatalError("Error adding camera to capture session.")
        }
        captureSession.addInput(cameraInput)
        if captureSession.canSetSessionPreset(.hd1920x1080) {
            captureSession.sessionPreset = .hd1920x1080
        }
        
        // Add outputs
        guard captureSession.canAddOutput(fileOutput) else {
            fatalError("Error: Cannot save movie with capture session.")
        }
        // TODO: Start/Stop Session
    }
    
    private func bestCamera() ->  AVCaptureDevice {
        // Ultra-wide lens (iPhone 11 Pro Max on back)
        do {
            if let ultraWideCamera = AVCaptureDevice.default(.builtInUltraWideCamera, for: .video, position: .back) {
                return ultraWideCamera
            }
        // Wide angle lenes
            if let wideAngleCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
                return wideAngleCamera
            }
            fatalError("Are you on an iphone simulator? ")
        }
    }
    // Recording
    @IBAction func recordButtonPressed(_ sender: Any) {
        toggleRecord()
    }
    @IBAction func recordButtonPressedFromMenuBar(_ sender: Any) {
        toggleRecord()
    }
	
	/// Creates a new file URL in the documents directory
	private func newRecordingURL() -> URL {
		let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

		let formatter = ISO8601DateFormatter()
		formatter.formatOptions = [.withInternetDateTime]

		let name = formatter.string(from: Date())
		let fileURL = documentsDirectory.appendingPathComponent(name).appendingPathExtension("mov")
        ExperienceController.shared.videoURL = fileURL
        print(ExperienceController.shared.videoURL as Any)
		return fileURL
	}
    private func playMovie(url: URL) {
        player = AVPlayer(url: url)
        let playerView = VideoPlayerView()
        playerView.player = player
        // top left corner (Fullscreen, you'd need a close button)
        var topRect = view.bounds
        topRect.size.height = topRect.size.height / 4
        topRect.size.width = topRect.size.width / 4 // create a constant for the "magic number"
        topRect.origin.y = view.layoutMargins.top
        playerView.frame = topRect
        view.addSubview(playerView) // FIXME: Don't add every time we play
        player.play()
    }
}


extension CameraViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo fileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let error = error {
            print("Error saving video: \(error)")
        }
        updateViews()
    }
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        print("startedRecording: \(fileURL)")
        updateViews()
    }
}
