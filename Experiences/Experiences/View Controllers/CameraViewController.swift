//
//  CameraViewController.swift
//  Experiences
//
//  Created by Scott Bennett on 11/9/18.
//  Copyright © 2018 Scott Bennett. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class CameraViewController: UIViewController, AVCaptureFileOutputRecordingDelegate {
    
    // MARK: - Properties
    
    private var captureSession: AVCaptureSession!
    private var recordOutput: AVCaptureMovieFileOutput!
    
    
    @IBOutlet weak var previewView: CameraPreviewView!
    @IBOutlet weak var recordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Video Recording"
        
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
    
    
    @IBAction func toggleRecord(_ sender: Any) {
        if recordOutput.isRecording {
            recordOutput.stopRecording()
        } else {
            recordOutput.startRecording(to: newRecordingURL(), recordingDelegate: self)
        }
    }
    
    // MARK: AVCaptureFileOutputRecordingDelegate
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        DispatchQueue.main.async {
            self.updateViews()
        }
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        DispatchQueue.main.async {
            self.updateViews()
            
            
            // Save video to Photo Library
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status != .authorized {
                    NSLog("Please give VideoFilters access to your photos in settings")
                    return
                }
                
                //TODO: - remove file from documents directory
                
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputFileURL)
                }, completionHandler: { (success, error) in
                    if let error = error {
                        NSLog("Error saving video to photo library: \(error)")
                    }
                })
            })
        }
    }
    
    
    // MARK: - Private
    
    private func updateViews() {
        guard isViewLoaded else { return }
        
        let recordButtonImageName = recordOutput.isRecording ? "Stop" : "Record"
        recordButton.setImage(UIImage(named: recordButtonImageName), for: .normal)
    }
    
    
    private func setupCapture() {
        let captureSession = AVCaptureSession()                                     // Setup session
        let device = bestCamera()                                                   // Get a device
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: device),     // Add an input, it throws
            captureSession.canAddInput(videoDeviceInput) else {
                fatalError()
        }
        captureSession.addInput(videoDeviceInput)                                    // If we can create input and add it
        
        let fileOutput = AVCaptureMovieFileOutput()
        guard captureSession.canAddOutput(fileOutput) else {
            fatalError()
        }
        captureSession.addOutput(fileOutput)
        recordOutput = fileOutput
        
        captureSession.sessionPreset = .hd1920x1080
        captureSession.commitConfiguration()
        
        self.captureSession = captureSession
        // previewView is an outlet to the view
        previewView.videoPreviewLayer.session = captureSession                      // Send to the UIView and just give it the session and it will do it
        
    }
    
    
    // Get the best back camera, could let user choose campera here to be fancier
    private func bestCamera() -> AVCaptureDevice {
        if let device = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) {    // Could fail
            return device
        } else if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {   // Should work on any device with camera
            return device
        } else {
            fatalError("Missing expected back camera device")    // Something is seriously wrong
        }
        
    }
    
    
    private func newRecordingURL() -> URL {
        let fm = FileManager.default
        let documentsDirectory = try! fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        return documentsDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("mov")
        
    }
    
    


}
