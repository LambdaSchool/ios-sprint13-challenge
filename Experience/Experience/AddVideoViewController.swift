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
import MapKit

class AddVideoViewController: UIViewController, AVCaptureFileOutputRecordingDelegate, CLLocationManagerDelegate
{
    @IBOutlet var videoRecordingButton: UIButton!
    @IBOutlet var previewView: CameraPreviewView!
    
    var experienceController: ExperienceController!
    var experience: Experience?
    private var captureSession: AVCaptureSession!
    private var recordOutput: AVCaptureMovieFileOutput!
    
    var experienceTitle: String?
    var image: UIImage?
    var audioURL: URL?
    var videoURL: URL?
    private lazy var locationManager: CLLocationManager = {
        let result = CLLocationManager()
        result.delegate = self
        return result
    }()
    
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
            
            self.experience?.videoURL = outputFileURL
            
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
            self.saveExperience()
            self.performSegue(withIdentifier: "unwindToMapView", sender: self)
        }
    }
    
    func saveExperience()
    {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        guard let title = experienceTitle,
            let image = image,
            let audioURL = audioURL,
            let videoURL = videoURL,
            let location = locationManager.location else { return }
        locationManager.stopUpdatingLocation()
        
        let coordinate = location.coordinate
        
        experienceController.addExperience(title: title, audioURL: audioURL, videoURL: videoURL, image: image, coordinate: coordinate)
    }
}
