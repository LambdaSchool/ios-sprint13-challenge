//
//  VideoViewController.swift
//  Experiences
//
//  Created by Aaron Cleveland on 3/13/20.
//  Copyright © 2020 Aaron Cleveland. All rights reserved.
//

import UIKit
import AVFoundation

class VideoViewController: UIViewController, AVCaptureFileOutputRecordingDelegate {
    
    @IBOutlet weak var videoPreviewView: CameraView!
    @IBOutlet weak var recordButton: UIButton!
    
    var videoHasBeenRecorded = false
    var experience: Experience!
    var expController: ExpController!
    var captureSession: AVCaptureSession!
    var recordOutput: AVCaptureMovieFileOutput!
    
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
    
    
    @IBAction func record(_ sender: Any) {
        if recordOutput.isRecording {
            recordOutput.stopRecording()
        } else {
            recordOutput.startRecording(to: experience.videoURL, recordingDelegate: self)
            
        }
    }
    
    @IBAction func saveExperience(_ sender: Any) {
        guard videoHasBeenRecorded else { return }
        
        expController.saveExp(experience)
        dismiss(animated: true, completion: nil)
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        DispatchQueue.main.async { self.updateViews() }
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        DispatchQueue.main.async {
            defer {
                self.videoHasBeenRecorded = true
                self.updateViews()
            }
        }
    }
    
    private func updateViews() {
        guard isViewLoaded else { return }
        
        let isRecording = recordOutput?.isRecording ?? false
        let recordButtonImage = isRecording ? "Stop" : "Record"
        recordButton.setImage(UIImage(named: recordButtonImage), for: .normal)
    }
    
    private func showCamera() {
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
        videoPreviewView.videoLayer.session = captureSession
        
    }
    
    
    private func bestCamera() -> AVCaptureDevice {
        if let device = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) {
            return device
        } else if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            return device
        } else {
            fatalError("Missing expected back camera device.")
        }
    }
}
