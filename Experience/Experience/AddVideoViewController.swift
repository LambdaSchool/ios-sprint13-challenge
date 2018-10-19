//
//  AddVideoViewController.swift
//  Experience
//
//  Created by Carolyn Lea on 10/19/18.
//  Copyright © 2018 Carolyn Lea. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class AddVideoViewController: UIViewController, AVCaptureFileOutputRecordingDelegate
{
    @IBOutlet var videoRecordingButton: UIButton!
    @IBOutlet var previewView: CameraPreviewView!
    
    private var captureSession: AVCaptureSession!
    private var recordOutput: AVCaptureMovieFileOutput!
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        captureSession.startRunning()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setupCapture()
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        captureSession.stopRunning()
    }
    
    @IBAction func record(_ sender: Any)
    {
        if recordOutput.isRecording
        {
            recordOutput.stopRecording()
        }
        else
        {
            recordOutput.startRecording(to: newRecordingURL(), recordingDelegate: self)
        }
    }
    
    // MARK: Private
    
    private func bestCamera() -> AVCaptureDevice
    {
        if let device = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back)
        {
            return device
        }
        else if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
        {
            return device
        }
        else
        {
            fatalError("Missing expected back camera device")
        }
    }
    
    private func setupCapture()
    {
        let captureSession = AVCaptureSession()
        let device = bestCamera()
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: device),
            captureSession.canAddInput(videoDeviceInput) else
        {
            fatalError()
        }
        captureSession.addInput(videoDeviceInput)
        
        let fileOutput = AVCaptureMovieFileOutput()
        guard captureSession.canAddOutput(fileOutput) else {fatalError()}
        captureSession.addOutput(fileOutput)
        recordOutput = fileOutput
        captureSession.sessionPreset = .hd1920x1080
        captureSession.commitConfiguration()
        
        self.captureSession = captureSession
        previewView.videoPreviewLayer.session = captureSession
    }
    
    private func newRecordingURL() -> URL
    {
        let fm = FileManager.default
        let documentsDir = try! fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        return documentsDir.appendingPathComponent(UUID().uuidString).appendingPathExtension("mov")
    }
    
    private func updateViews()
    {
        guard isViewLoaded else {return}
        
        let recordButtonImageName = recordOutput.isRecording ? "Stop" : "Record"
        videoRecordingButton.setImage(UIImage(named: recordButtonImageName), for: .normal)
    }
    
    // MARK: AVCaptureFileOutputRecordingDelegate
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection])
    {
        DispatchQueue.main.async {
            self.updateViews()
        }
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?)
    {
        DispatchQueue.main.async {
            
            self.updateViews()
            
            PHPhotoLibrary.requestAuthorization({(status) in
                if status != .authorized
                {
                    NSLog("Please give permission")
                    return
                }
                
                PHPhotoLibrary.shared().performChanges ({
                    
                    PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputFileURL)
                    
                }, completionHandler: { (success, error) in
                    
                    if let error = error
                    {
                        NSLog("error saving: \(error)")
                    }
                })
            })
            self.performSegue(withIdentifier: "unwindToMapView", sender: self)
        }
    }
}
