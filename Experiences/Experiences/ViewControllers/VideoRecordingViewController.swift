//
//  VideoRecordingViewController.swift
//  Experiences
//
//  Created by Kobe McKee on 7/11/19.
//  Copyright © 2019 Kobe McKee. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class VideoRecordingViewController: UIViewController, AVCaptureFileOutputRecordingDelegate {
    
    @IBOutlet weak var cameraPreviewView: CameraPreviewView!
    @IBOutlet weak var recordButton: UIButton!
    
    var captureSession = AVCaptureSession()
    var recordOutput = AVCaptureMovieFileOutput()
    var videoURL: URL?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authorizeCameraAccess()
        setupCaptureSession()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        captureSession.startRunning()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        captureSession.stopRunning()
    }
    
    
    func updateViews() {
        let isRecording = recordOutput.isRecording
        
        let recordButtonImage = isRecording ? "Stop" : "Record"
        recordButton.setImage(UIImage(named: recordButtonImage), for: .normal)
    }
    
    
    func authorizeCameraAccess() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            return
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (granted) in
                if granted {
                    return
                } else {
                    NSLog("Camera authorization not given")
                }
            }
        case .denied:
            NSLog("Camera authorization denied")
            
        case .restricted:
            NSLog("Camera authorization restricted")
            
            
            
        }
    }
    
    
    func setupCaptureSession() {
        let captureSession = AVCaptureSession()
        let cameraDevice = bestCamera()
        
        guard let audioDevice = AVCaptureDevice.default(for: .audio) else { return }
        
        guard let cameraDeviceInput = try? AVCaptureDeviceInput(device: cameraDevice),
                captureSession.canAddInput(cameraDeviceInput) else {
            fatalError("Unable to create camera input")
        }
        
        guard let audioDeviceInput = try? AVCaptureDeviceInput(device: audioDevice) else {return}
        
        captureSession.addInput(cameraDeviceInput)
        captureSession.addInput(audioDeviceInput)
        
        let fileOutput = AVCaptureMovieFileOutput()
        
        guard captureSession.canAddOutput(fileOutput) else {
            fatalError("Unable to add video file")
        }
        
        captureSession.addOutput(fileOutput)
        
        captureSession.sessionPreset = .hd1920x1080
        captureSession.commitConfiguration()
        
        self.captureSession = captureSession
        self.recordOutput = fileOutput
        
        cameraPreviewView.videoPreviewLayer.session = captureSession
    }
    
    func bestCamera() -> AVCaptureDevice {
        if let device = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) {
            return device
        } else  if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            return device
            
        } else {
            fatalError("Missing expected back camera on device")
        }
    }
    
    
     @IBAction func recordButtonPressed(_ sender: Any) {
     }


    func saveVideoRecording(with url: URL) {
        
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized else { return }
            PHPhotoLibrary.shared().performChanges({
                PHAssetCreationRequest.creationRequestForAssetFromVideo(atFileURL: url)
            }, completionHandler: { (success, error) in
                if let error = error {
                    NSLog("Error saving video: \(error)")
                }
            })
        }
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        DispatchQueue.main.async {
            self.updateViews()
        }
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        
        self.videoURL = outputFileURL
        DispatchQueue.main.async {
            
            defer {self.updateViews()}
            
            PHPhotoLibrary.requestAuthorization({ (status) in
                guard status == .authorized else {
                    NSLog("Please give video filterd access to photo library in settings")
                    return
                }
                
                PHPhotoLibrary.shared().performChanges({
                    PHAssetCreationRequest.creationRequestForAssetFromVideo(atFileURL: outputFileURL)
                    
                }, completionHandler: { (success, error) in
                    try! FileManager.default.removeItem(at: outputFileURL)
                    
                    if let error = error {
                        NSLog("Error saving video to phopto library: \(error)")
                    }
                })
            })
        }
    }
    
}
