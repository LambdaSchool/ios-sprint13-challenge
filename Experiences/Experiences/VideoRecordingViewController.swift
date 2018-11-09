//
//  VideoRecordingViewController.swift
//  Experiences
//
//  Created by Daniela Parra on 11/9/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import UIKit
import MapKit
import AVFoundation

class VideoRecordingViewController: UIViewController, AVCaptureFileOutputRecordingDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpSession()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        captureSession?.startRunning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        captureSession?.stopRunning()
    }
    
    @IBAction func saveExperience(_ sender: Any) {
        guard let experienceController = experienceController,
            let unfinishedExperience = unfinishedExperience,
            let videoURL = videoURL else { return }
        
        let experience = experienceController.createExperience(from: unfinishedExperience, videoURL: videoURL)
        
        guard let mapView = mapView else {
            NSLog("No map view passed")
            return
        }
        
        mapView.addAnnotation(experience)
        performSegue(withIdentifier: "UnwindToFirstVC", sender: self)
    }
    
    
    @IBAction func record(_ sender: Any) {
        if recordingOutput.isRecording {
            recordingOutput.stopRecording()
        } else {
            recordingOutput.startRecording(to: newRecordingURL(), recordingDelegate: self)
        }
    }
    
    // MARK: - AVCaptureFileOutputRecordingDelegate
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        DispatchQueue.main.async {
            self.updateButton()
        }
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        DispatchQueue.main.async {
            self.updateButton()
        }
        
        self.videoURL = outputFileURL
    }
    
    // MARK: - Private Methods
    
    private func setUpSession() {
        
        let captureSession = AVCaptureSession()
        let cameraDevice = bestCamera()
        
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: cameraDevice), captureSession.canAddInput(videoDeviceInput) else { fatalError("Error: can't use camera and need one.")}
        
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
    
    private func bestCamera() -> AVCaptureDevice {
        if let device = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) {
            return device
        } else if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            return device
        } else {
            fatalError("Missing back camera device")
        }
        
    }
    
    private func updateButton() {
        guard isViewLoaded else { return }
        
        let isRecording = recordingOutput.isRecording
        let recordButtonImageTitle = isRecording ? "Stop" : "Record"
        let image = UIImage(named: recordButtonImageTitle)
        videoRecordButton.setImage(image, for: .normal)
    }
    
    private func newRecordingURL() -> URL {
        let fm = FileManager.default
        let documentsDir = try! fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        return documentsDir.appendingPathComponent(UUID().uuidString).appendingPathExtension("mov")
    }
    
    var experienceController: ExperienceController?
    var unfinishedExperience: Experience?
    var videoURL: URL?
    var mapView: MKMapView?
    
    var captureSession: AVCaptureSession!
    var recordingOutput: AVCaptureMovieFileOutput!

    @IBOutlet weak var previewView: CameraPreviewView!
    @IBOutlet weak var videoRecordButton: UIButton!
}
