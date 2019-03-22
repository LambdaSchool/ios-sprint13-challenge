//
//  VideoViewController.swift
//  Experiences
//
//  Created by Moses Robinson on 3/22/19.
//  Copyright © 2019 Moses Robinson. All rights reserved.
//

import UIKit
import AVFoundation

class VideoViewController: UIViewController, AVCaptureFileOutputRecordingDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCaptureSession()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        captureSession.startRunning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        captureSession.stopRunning()
    }
    
    @IBAction func record(_ sender: Any) {
        
        if recordOutput.isRecording {
            recordOutput.stopRecording()
        } else {
            recordOutput.startRecording(to: newRecordingURL(), recordingDelegate: self)
        }
    }
    
    @IBAction func saveAndCreateExperience(_ sender: Any) {
        
        guard experienceController?.videoURL != nil else { return }
        
        experienceController?.createExperience()
        
        dismiss(animated: true, completion: nil)
    }
    
    
    func setupCaptureSession() {
        
        // Make the capture session
        let captureSession = AVCaptureSession()
        
        // Configure the input(s)
        let cameraDevice = bestCamera()
        
        guard let cameraDeviceInput = try? AVCaptureDeviceInput(device: cameraDevice),
            /* this checks that input can be added to the session */   captureSession.canAddInput(cameraDeviceInput) else {
                fatalError("Unable to create camera input")
        }
        
        // "Take this camera and use it to record video when the session begins"
        captureSession.addInput(cameraDeviceInput)
        
        // Configure the Output
        
        let fileOutput = AVCaptureMovieFileOutput()
        
        guard captureSession.canAddOutput(fileOutput) else {
            fatalError("Unable to add movie file output to capture session")
        }
        
        captureSession.addOutput(fileOutput)
        
        // Configure the session
        
        captureSession.sessionPreset = .hd1920x1080
        
        // Lock in the input(s), outputs, session presets, etc.
        captureSession.commitConfiguration()
        
        self.captureSession = captureSession
        self.recordOutput = fileOutput
        
        // Gives the video information (frames) to the preview to be shown to the user
        previewView.videoPreviewLayer.session = captureSession
    }
    
    private func newRecordingURL() -> URL {
        
        let documentDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        return documentDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("mov")
    }
    
    private func updateViews() {
        
        let isRecording = recordOutput.isRecording
        
        let recordButtonImage = isRecording ? "Stop" : "Record"
        recordButton.setImage(UIImage(named: recordButtonImage), for: .normal)
    }
    
    private func bestCamera() -> AVCaptureDevice {
        
        if let device = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) {
            // the user's device has a dual camera system (iPhone Plus, X, etc.)
            return device
        } else if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            // the user's device has a single camera system (iPhone 8, etc.)
            return device
        } else {
            fatalError("MIssing expected back camera device. ")
        }
    }
    
    // MARK: - AVCaptureFileOutputRecordingDelegate
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        
        DispatchQueue.main.async {
            self.updateViews()
        }
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        
        DispatchQueue.main.async {
            
            defer { self.updateViews() }
            self.experienceController?.videoURL = outputFileURL
        }
    }
    
    // MARK: - Properties
    
    var experienceController: ExperienceController?

    var captureSession: AVCaptureSession!
    var recordOutput: AVCaptureMovieFileOutput!
    
    @IBOutlet var previewView: VideoPreviewView!
    @IBOutlet var recordButton: UIButton!
}
