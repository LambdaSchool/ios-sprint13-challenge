//
//  VideoViewController.swift
//  Experiences
//
//  Created by Aaron Cleveland on 3/13/20.
//  Copyright © 2020 Aaron Cleveland. All rights reserved.
//

import UIKit
import AVFoundation

class VideoViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var videoPreview: CameraView!
    @IBOutlet weak var recordButton: UIButton!
    
    // MARK: - Variables
    var captureSession: AVCaptureSession!
    var recordOutput: AVCaptureMovieFileOutput!
    var experience: Experience!
    var expController: ExpController!
    var videoHasBeenRecorded = false
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            self.showCamera()
            captureSession.startRunning()
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    self.showCamera()
                    self.captureSession.startRunning()
                }
            }
        default:
            return
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        captureSession.stopRunning()
    }
    
    // MARK: - IBActions
    @IBAction func saveExp(_ sender: Any) {
        guard videoHasBeenRecorded else { return }
        
        expController.saveExp(experience)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func record(_ sender: Any) {
        if recordOutput.isRecording {
            recordOutput.stopRecording()
        } else {
            recordOutput.startRecording(to: experience.videoURL, recordingDelegate: self)
        }
    }
    
    // MARK: - Helper Functions
    func updateViews() {
        guard isViewLoaded else { return }
        
        let isRecording = recordOutput?.isRecording ?? false
        let recordButtonImage = isRecording ? "Stop" : "Record"
        recordButton.setImage(UIImage(named: recordButtonImage), for: .normal)
    }
    
    func showCamera() {
        let captureSession = AVCaptureSession()
        let videoDevice = bestCamera()
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice),
            captureSession.canAddInput(videoDeviceInput) else {
                fatalError()
        }
        captureSession.addInput(videoDeviceInput)
        
        let fileOutput = AVCaptureMovieFileOutput()
        guard captureSession.canAddOutput(fileOutput) else { fatalError() }
        captureSession.addOutput(fileOutput)
        recordOutput = fileOutput
        
        captureSession.sessionPreset = .hd1920x1080
        captureSession.commitConfiguration()
        
        self.captureSession = captureSession
        videoPreview.videoLayer.session = captureSession
        
    }
    
    
    func bestCamera() -> AVCaptureDevice {
        if let device = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) {
            return device
        } else if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            return device
        } else {
            fatalError("Missing expected back camera device.")
        }
    }
}

extension VideoViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        DispatchQueue.main.async { self.updateViews() }
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        DispatchQueue.main.async {
            do {
                self.videoHasBeenRecorded = true
                self.updateViews()
            }
        }
    }
}
