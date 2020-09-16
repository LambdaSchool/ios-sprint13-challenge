//
//  CameraViewController.swift
//  VideoFilter
//
//  Created by Farhan on 11/7/18.
//  Copyright © 2018 Farhan. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class CameraViewController: UIViewController, AVCaptureFileOutputRecordingDelegate {
    
    // Properties
    
    var experienceController: ExperienceController?{
        didSet{
            NSLog("Final Experience Controller created")
        }
    }
    var experience: Experience?
    
    //Local Methods
    
    
    @IBAction func createExperience(_ sender: Any) {
        
        guard let experience = experience else {return}
        
        experienceController?.addExperience(experience: experience)
        
        navigationController?.popToRootViewController(animated: true)
        
    }
    
    // MARK: AVCaptureFileOutputRecording methods
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        DispatchQueue.main.async {
            defer{self.updateButton()}
            
            // saves to local photolibrary
            PHPhotoLibrary.requestAuthorization { (status) in
                
                if status == .authorized {
                    
                    PHPhotoLibrary.shared().performChanges({
                        PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputFileURL)
                    }, completionHandler: { (success, error) in
                        if let error = error {
                            NSLog("Error Saving Video to PhotoLibrary: \(error)")
                            return
                        }
                        
                        print("Save successfull")
                    })
                    
                } else {
                    NSLog("Not Authorized")
                }
            }
            
        }
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        DispatchQueue.main.async {
            self.updateButton()
        }
    }
    
    
    var captureSession: AVCaptureSession!
    var recordingOutput: AVCaptureMovieFileOutput!
    

    @IBOutlet weak var cameraPreviewView: CameraPreviewView!
    @IBOutlet weak var recordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let captureSession = AVCaptureSession()
        let cameraDevice = chooseBestCamera()
        
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: cameraDevice), captureSession.canAddInput(videoDeviceInput) else {fatalError("Could not get videoDeviceInput")}
        
        captureSession.addInput(videoDeviceInput)
        
        let fileOutput = AVCaptureMovieFileOutput()
        
        guard captureSession.canAddOutput(fileOutput) else {fatalError()}
        
        captureSession.addOutput(fileOutput)
        captureSession.sessionPreset = .hd1920x1080
        captureSession.commitConfiguration()
        
        recordingOutput = fileOutput
        self.captureSession = captureSession
        
        cameraPreviewView.videoPreviewLayer.session = captureSession
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        captureSession?.startRunning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        captureSession?.stopRunning()
    }
    
    
    @IBAction func record(_ sender: Any) {
        
//        defer {updateButton()}
        
        if recordingOutput.isRecording {
            recordingOutput.stopRecording()
        }else {
            recordingOutput.startRecording(to: newRecordingURL(), recordingDelegate: self)
        }
    }
    
    private func updateButton() {
        guard isViewLoaded else {return}
        
        let isRecording = recordingOutput.isRecording
        
        let recordButtonImageTitle = isRecording ? "Stop" : "Record"
        let image = UIImage(named: recordButtonImageTitle)
        recordButton.setImage(image, for: .normal)
    }
    
    private func newRecordingURL() -> URL {
        let fm = FileManager.default
        let documentsDir = try! fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        return documentsDir.appendingPathComponent(UUID().uuidString).appendingPathExtension("mov")
    }
    
    private func chooseBestCamera() -> AVCaptureDevice {
        
        if let device = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) {
            return device
        } else if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
        {
            return device
        } else {
            fatalError("missing back camera")
        }
        
    }
    

}
