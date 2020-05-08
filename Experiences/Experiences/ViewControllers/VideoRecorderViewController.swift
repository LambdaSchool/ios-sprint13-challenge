//
//  VideoRecorderViewController.swift
//  VideoPost
//
//  Created by Shawn Gee on 5/6/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import UIKit
import AVFoundation

protocol VideoRecorderDelegate: AnyObject {
    func didRecordVideo(to url: URL)
}

class VideoRecorderViewController: UIViewController {
    
    // MARK: - Public Properties
    
    weak var delegate: VideoRecorderDelegate?
    
    // MARK: - Private Properties
    
    lazy private var captureSession = AVCaptureSession()
    lazy private var fileOutput = AVCaptureMovieFileOutput()

    // MARK: - IBOutlets
    
    @IBOutlet var recordButton: UIButton!
    @IBOutlet var cameraView: CameraPreviewView!

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Resize camera preview to fill the entire screen
        cameraView.videoPlayerView.videoGravity = .resizeAspectFill
        setUpCaptureSession()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        captureSession.startRunning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        captureSession.stopRunning()
    }
    
    // MARK: - Private Methods
    
    private func updateViews() {
        recordButton.isSelected = fileOutput.isRecording
    }
    
    // Live Preview + inputs/outputs
    
    private func setUpCaptureSession() {
        // Add inputs
        captureSession.beginConfiguration()
        
        // Camera input
        let camera = bestCamera()
        
        guard let cameraInput = try? AVCaptureDeviceInput(device: camera),
            captureSession.canAddInput(cameraInput) else {
                fatalError("Error adding camera to capture session")
        }
        captureSession.addInput(cameraInput)
        
        if captureSession.canSetSessionPreset(.hd1920x1080) {
            captureSession.sessionPreset = .hd1920x1080
        }
        
        // Microphone input
        
        // Add outputs
        guard captureSession.canAddOutput(fileOutput) else {
            fatalError("Can not save movie to file")
        }
        captureSession.addOutput(fileOutput)
        
        captureSession.commitConfiguration()
        cameraView.session = captureSession
    }
    
    private func bestCamera() -> AVCaptureDevice {
        // FUTURE: Toggle between front/back with a button
        
        // Ultra-wide lens (iPhone 11 Pro + Pro Max on back)
        if let ultraWideCamera = AVCaptureDevice.default(.builtInUltraWideCamera, for: .video, position: .back) {
            return ultraWideCamera
        }
        
        // Wide angle lens (any iPhone - front/back)
        if let wideAngleCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            return wideAngleCamera
        }
        
        // No cameras present (simulator)
        fatalError("No camera available - are you on a simulator?")
    }

    private func toggleRecord() {
        if fileOutput.isRecording {
            fileOutput.stopRecording()
        } else {
            fileOutput.startRecording(to: newRecordingURL(), recordingDelegate: self)
        }
    }
    
    /// Creates a new file URL in the temporary directory
    private func newRecordingURL() -> URL {
        let temporaryDirectory = FileManager.default.temporaryDirectory

        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]

        let name = formatter.string(from: Date())
        let fileURL = temporaryDirectory.appendingPathComponent(name).appendingPathExtension("mov")
        return fileURL
    }
    
    // MARK: - IBActions
    
    @IBAction func recordButtonPressed(_ sender: Any) {
        toggleRecord()
    }
}

// MARK: - AV Capture File Output Recording Delegate

extension VideoRecorderViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let error = error {
            print("⚠️ Error recording video to file: \(error)")
        } else {
            delegate?.didRecordVideo(to: outputFileURL)
            dismiss(animated: true)
        }
        updateViews()
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        print("Started recording at \(fileURL)")
        updateViews()
    }
}
