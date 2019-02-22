//
//  CameraViewController.swift
//  VideoRecording
//
//  Created by Austin Cole on 2/20/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class CameraViewController: UIViewController, AVCaptureFileOutputRecordingDelegate {
    //MARK: Private Properties
    private let captureSession = AVCaptureSession()
    private let fileOutput = AVCaptureMovieFileOutput()
    private var saveURL = URL(fileURLWithPath: "Hello")
    
    //MARK: Non-Private Properties
    var userExperience: UserExperience?
    var userExperienceController: UserExperienceController?
    
    //MARK: IBOutlets
    @IBOutlet weak var cameraView: CameraPreviewView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set up the capture session
        //SessionInputs
        let camera = bestCamera()
        //See if device is available to use for capture
        guard let cameraInput = try? AVCaptureDeviceInput(device: camera) else {
            fatalError("Device is unavailable to use for capture. Do something better than crashing.")
        }
        guard captureSession.canAddInput(cameraInput) else {
            fatalError("This session can't handle this kind of input")
        }
        captureSession.addInput(cameraInput)
        
        
        //SessionOutputs
        guard captureSession.canAddOutput(fileOutput) else {
            fatalError("Could not use output")
        }
        captureSession.addOutput(fileOutput)
        
        //First check to see if the device is capable of a certain quality of capture, and then set the quality of the capture
        if captureSession.canSetSessionPreset(.hd1920x1080) {
            captureSession.sessionPreset = .hd1920x1080
        } else {
            captureSession.sessionPreset = .high
        }
        captureSession.commitConfiguration()
        
        cameraView.session = captureSession
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        captureSession.startRunning()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        captureSession.stopRunning()
    }
    
    //MARK: AVCaptureFileOutputRecordingDelegate Methods
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        DispatchQueue.main.async {
        self.updateViews()
        }
    }
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        DispatchQueue.main.async {
            self.updateViews()
        }
        saveURL = outputFileURL
    }
    
    //MARK: IBActions
    @IBAction func saveButtonWasTapped(_ sender: Any) {
        saveVideo()
    }
    
    @IBAction func toggleRecord(_ sender: Any) {
        if fileOutput.isRecording {
            fileOutput.stopRecording()
        } else {
            fileOutput.startRecording(to: newRecordingURL(), recordingDelegate: self)
        }
        
    }
    
    
    
    //MARK: Private Methods
    private func bestCamera() -> AVCaptureDevice {
        if let device = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) {
            return device
        }
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            return device
        }
        fatalError("This device has no camera")
    }
    
    private func newRecordingURL() -> URL {
        let fm = FileManager.default
        let documents = try! fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        //Format current date and time. Everytime we hit start and stop we will get a different file name based on the current date and time.
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime]
        
        let name = f.string(from: Date())
        return documents.appendingPathComponent(name).appendingPathExtension("mov")
    }
    
    private func saveVideo() {
        userExperienceController?.addVideoExperience(userExperience: userExperience!, videoURL: saveURL)
    }
    
    private func updateViews() {
        let isRecording = fileOutput.isRecording
        recordButton.setTitle(isRecording ? "Stop" : "Start", for: .normal)
    }
    
    
}
