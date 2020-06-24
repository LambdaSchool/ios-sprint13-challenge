//
//  CameraViewController.swift
//  Experiences
//
//  Created by Ryan Murphy on 7/12/19.
//  Copyright © 2019 Ryan Murphy. All rights reserved.
//

import UIKit
import AVFoundation


class CameraViewController: UIViewController, AVCaptureFileOutputRecordingDelegate {

    let locationHelper = LocationHelper()
    
    var experienceController: ExperienceController?
    var audioURL: URL?
    var imageTitle: String?
    var imageData: Data?
    var videoURL: URL?
    var captureSession: AVCaptureSession!
    var recordingOutput: AVCaptureMovieFileOutput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let captureSession = AVCaptureSession()
        
        let cameraDevice = bestCamera()
        
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: cameraDevice),
            captureSession.canAddInput(videoDeviceInput) else { fatalError() }
        captureSession.addInput(videoDeviceInput)
        
        let fileOutput = AVCaptureMovieFileOutput()
        
        guard captureSession.canAddOutput(fileOutput) else { fatalError() }
        captureSession.addOutput(fileOutput)
        captureSession.sessionPreset = .hd1920x1080
        captureSession.commitConfiguration()
        
        recordingOutput = fileOutput
        self.captureSession = captureSession
        previewView.videoPreviewLayer.session = captureSession
    }
    
    @IBOutlet weak var previewView: CameraView!
    @IBOutlet weak var recordVideoButton: UIButton!
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        DispatchQueue.main.async {
            self.updateButton()
        }
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        DispatchQueue.main.async {
            do { self.updateButton() }
        }
        videoURL = outputFileURL
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        captureSession?.startRunning()
    }
    
    func updateButton() {
        guard isViewLoaded else { return }
        
        let isRecording = recordingOutput.isRecording
        let recordButtonImageTitle = isRecording ? "Stop" : "Record Audio"
        let image = UIImage(named: recordButtonImageTitle)
        recordVideoButton.setImage(image, for: .normal)
        
    }
    
    
    
    private func newRecordingURL() -> URL {
        let fm = FileManager.default
        let documentsDir = try! fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        return documentsDir.appendingPathComponent(UUID().uuidString).appendingPathExtension("mov")
    }
    
    private func bestCamera() -> AVCaptureDevice {
        if let device = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) {
            return device
        } else if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            return device
        } else {
            fatalError("No rear camera")
        }
    }
    
    
    @IBAction func recordVideoButtonPressed(_ sender: Any) {
        if recordingOutput.isRecording {
            recordingOutput.stopRecording()
        } else {
            recordingOutput.startRecording(to: newRecordingURL(), recordingDelegate: self)
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        guard let imageTitle = imageTitle,
            let videoURL = videoURL,
            let coordinate = locationHelper.getCurrentLocation()?.coordinate,
            let audioURL = audioURL,
            let imageData = imageData else { return }
        
        experienceController?.createExperience(title: imageTitle, coordinate: coordinate, videoURL: videoURL, audioURL: audioURL, imageData: imageData)
        
        dismiss(animated: true, completion: nil)
    }
}
