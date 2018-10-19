//
//  VideoViewController.swift
//  Experiences
//
//  Created by Linh Bouniol on 10/19/18.
//  Copyright © 2018 Linh Bouniol. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation

class VideoViewController: UIViewController, AVCaptureFileOutputRecordingDelegate {
    
    var experienceController: ExperienceController!
    var experience: Experience?
    
    // these properties hold on to the values from ExperienceVC
    var experienceTitle: String?
    var imageURL: URL?
    var audioURL: URL?
    
    var videoURL: URL?
    
    private var captureSession: AVCaptureSession!
    private var recordOutput: AVCaptureMovieFileOutput!
    
    @IBOutlet weak var cameraPreviewView: CameraPreviewView!
    @IBOutlet weak var recordButton: UIButton!
    
    @IBAction func toggleRecordButton(_ sender: Any) {
        if recordOutput.isRecording {
            recordOutput.stopRecording()
        } else {
            // record and save to the url in directory
            videoURL = newRecordingURL()
            recordOutput.startRecording(to: videoURL!, recordingDelegate: self)
        }
    }
    
    @IBAction func done(_ sender: Any) {
        
        guard let experienceTitle = experienceTitle, let imageURL = imageURL, let audioURL = audioURL, let videoURL = videoURL else { return }
        
        experienceController.createExperience(withTitle: experienceTitle, imageURL: imageURL, audioURL: audioURL, videoURL: videoURL, coordinate: LocationHelper.shared.currentLocation?.coordinate ?? kCLLocationCoordinate2DInvalid)
        
        navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - View Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCapture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        captureSession.startRunning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        captureSession.stopRunning()
    }
    
    // MARK: - Methods
    
    private func setupCapture() {
        let captureSession = AVCaptureSession()
        let device = bestCamera()
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: device), captureSession.canAddInput(videoDeviceInput) else { fatalError() }
        
        captureSession.addInput(videoDeviceInput)
        
        let fileOutput = AVCaptureMovieFileOutput() // creates a movie file
        guard captureSession.canAddOutput(fileOutput) else { fatalError() } // make sure we can add it to captureSession
        captureSession.addOutput(fileOutput)
        recordOutput = fileOutput
        
        captureSession.sessionPreset = .hd1920x1080 // easier to filter with core image and process
        captureSession.commitConfiguration() // save all this stuff and actually set it up
        
        self.captureSession = captureSession    // starts off not running, so need to start it in viewWillAppear()
        cameraPreviewView.videoPreviewLayer.session = captureSession  // display the capture
    }
    
    private func bestCamera() -> AVCaptureDevice {
        // can allow user to choose different types of camera: dual, front, back
        if let device = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) {
            return device
        } else if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) { // one camera
            return device
        } else {
            fatalError("Missing expected back camera device")
        }
    }
    
    func updateViews() {
        guard isViewLoaded else { return }
        
        let recordingButtonImageName = recordOutput.isRecording ? "Stop" : "Record"
        recordButton.setImage(UIImage(named: recordingButtonImageName)!, for: .normal)
    }
    
    private func newRecordingURL() -> URL {
        let fm = FileManager.default
        let documentsDir = try! fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        return documentsDir.appendingPathComponent(UUID().uuidString).appendingPathExtension("mov")
    }
    
    // MARK: - AVCaptureFileOutputRecordingDelegate
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        DispatchQueue.main.async {
            self.updateViews()
        }
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        DispatchQueue.main.async {
            self.updateViews()
        }
    }

}
