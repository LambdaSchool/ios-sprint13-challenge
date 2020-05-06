//
//  RecordingViewController.swift
//  Experiences
//
//  Created by Jason Modisett on 1/18/19.
//  Copyright © 2019 Jason Modisett. All rights reserved.
//

import UIKit
import MapKit
import AVFoundation

class RecordingViewController: UIViewController, AVCaptureFileOutputRecordingDelegate {
    
    // MARK:- Types, properties, & IBOutlets
    
    var experienceController: ExperienceController?
    var experience: Experience?
    var videoURL: URL?
    var mapView: MKMapView?
    
    var captureSession: AVCaptureSession!
    var recordingOutput: AVCaptureMovieFileOutput!
    
    @IBOutlet weak var previewView: RecordingPreviewView!
    @IBOutlet weak var videoRecordButton: UIButton!
    
    
    // MARK:- View lifecycle methods
    
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
    
    
    // MARK:- Private methods
    
    private func setUpSession() {
        let captureSession = AVCaptureSession()
        let cameraDevice = bestCamera()
        
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: cameraDevice), captureSession.canAddInput(videoDeviceInput) else { fatalError("Error: can't use camera and need one")}
        
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
            fatalError("Missing back camera")
        }
    }
    
    private func updateButton() {
        guard isViewLoaded else { return }
        
        let isRecording = recordingOutput.isRecording
        let recordButtonImageName = isRecording ? "Stop" : "Record"
        let image = UIImage(named: recordButtonImageName)
        
        videoRecordButton.setImage(image, for: .normal)
    }
    
    private func newRecordingURL() -> URL {
        let fm = FileManager.default
        let documentsDir = try! fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        return documentsDir.appendingPathComponent(UUID().uuidString).appendingPathExtension("mov")
    }
    
    
    // MARK:- IBActions
    
    @IBAction func saveExperience(_ sender: Any) {
        
        guard let experienceController = experienceController,
            let experience = self.experience,
            let videoURL = videoURL else { return }
        
        let finishedExperience = experienceController.addVideoURL(to: experience, videoURL: videoURL)
        
        guard let mapView = mapView else {
            NSLog("No map view passed")
            return
        }
        
        mapView.addAnnotation(finishedExperience)
        performSegue(withIdentifier: "UnwindToMapVC", sender: self)
    }
    
    @IBAction func record(_ sender: Any) {
        if recordingOutput.isRecording {
            recordingOutput.stopRecording()
        } else {
            recordingOutput.startRecording(to: newRecordingURL(), recordingDelegate: self)
        }
    }
    
    
    // MARK:- AVCaptureFileOutput delegate methods
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        
        DispatchQueue.main.async { self.updateButton() }
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        
        DispatchQueue.main.async { self.updateButton() }
        self.videoURL = outputFileURL
    }
    
}
