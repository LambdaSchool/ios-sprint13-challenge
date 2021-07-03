//
//  VideoViewController.swift
//  Experiences
//
//  Created by Michael Stoffer on 10/3/19.
//  Copyright © 2019 Michael Stoffer. All rights reserved.
//

import UIKit
import Photos
import AVFoundation

class VideoViewController: UIViewController {
    
    // MARK: - Outlets and Properties
    
    @IBOutlet var cameraView: CameraView!
    @IBOutlet var recordButton: UIButton!
    
    var experienceController: ExperienceController?
    var experienceTitle: String?
    var imageData: Data?
    var audioRecordingURL: URL?
    
    var videoRecordingURL: URL?
    var captureSession: AVCaptureSession!
    var recordOutput: AVCaptureMovieFileOutput!

    override func viewDidLoad() {
        super.viewDidLoad()

        let captureSession = AVCaptureSession()
        let videoDevice = self.bestCamera()
        
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice),
            captureSession.canAddInput(videoDeviceInput) else { fatalError() }
        
        captureSession.addInput(videoDeviceInput)
        
        let fileOutput = AVCaptureMovieFileOutput()
        guard captureSession.canAddOutput(fileOutput) else { fatalError() }
        captureSession.addOutput(fileOutput)
        self.recordOutput = fileOutput
        
        captureSession.sessionPreset = .hd1920x1080
        captureSession.commitConfiguration()
        
        self.captureSession = captureSession
        cameraView.videoPreviewLayer.session = captureSession
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.captureSession.startRunning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.captureSession.stopRunning()
    }
    
    // MARK: - Actions and Methods
    
    @IBAction func recordButtonTapped(_ sender: UIButton) {
        if recordOutput.isRecording {
            recordOutput.stopRecording()
        } else {
            recordOutput.startRecording(to: self.newRecordingURL(), recordingDelegate: self)
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let title = self.experienceTitle,
            let imageData = self.imageData,
            let audioRecording = self.audioRecordingURL,
            let videoRecording = self.videoRecordingURL else { return }
        
        let locationHelper = LocationHelper()
        let coordinate = locationHelper.getCurrentLocation()!.coordinate
        
        self.experienceController?.createExperience(withExperienceTitle: title, withImageData: imageData, withAudioURL: audioRecording, withVideoURL: videoRecording, withCoordinate: coordinate)
        self.dismiss(animated: true)
    }
    
    private func bestCamera() -> AVCaptureDevice {
        if let device = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) {
            return device
        } else if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            return device
        } else {
            fatalError("Missing expected back camera device")
        }
    }
    
    private func newRecordingURL() -> URL {
        let fm = FileManager.default
        let documents = try! fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        return documents.appendingPathComponent(UUID().uuidString).appendingPathExtension("mov")
    }
    
    private func updateViews() {
        guard isViewLoaded else { return }
        
        let isRecording = recordOutput?.isRecording ?? false
        let recordButtonImageName: String = isRecording ? "Stop" : "Record"
        self.recordButton.setImage(UIImage(named: recordButtonImageName), for: .normal)
    }
}

extension VideoViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        DispatchQueue.main.async {
            self.updateViews()
        }
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        defer { self.updateViews() }
        
        self.videoRecordingURL = outputFileURL
    }
}
