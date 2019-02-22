//
//  CameraViewController.swift
//  Experiences
//
//  Created by Benjamin Hakes on 2/22/19.
//  Copyright © 2019 Benjamin Hakes. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class CameraViewController: UIViewController, AVCaptureFileOutputRecordingDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get authorization
        authorization()
        
        // Set up the capture session
        let camera = bestCamera()
        guard let cameraInput = try? AVCaptureDeviceInput(device: camera) else {
            fatalError("Can't create an input from the camera. Do something better than this (crashing).")
        }
        
        guard captureSession.canAddInput(cameraInput) else {
            fatalError("This session can't handle this kind of input.")
        }
        
        captureSession.addInput(cameraInput)
        
        guard captureSession.canAddOutput(fileOutput) else {
            fatalError("Cannot record to file")
        }
        captureSession.addOutput(fileOutput)
        
        if captureSession.canSetSessionPreset(.hd1920x1080) {
            captureSession.sessionPreset = .hd1920x1080
        } else {
            captureSession.sessionPreset = .high
        }
        captureSession.commitConfiguration()
        
        
        
        cameraView.session = captureSession
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        captureSession.startRunning()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        captureSession.stopRunning()
    }
    
    // MARK: - AVCaptureFileOutputRecordingDelegate
    // starting recording will take a fraction of a second,
    // we can't assume that it will start and stop recording
    // right away, it may have to finish writing data out to file
    // if we were to access the file being written to to quickly,
    // it may result in a corrupted file
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        DispatchQueue.main.async {
            self.updateViews()
        }
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        saveVideo(with: outputFileURL)
        DispatchQueue.main.async {
            self.updateViews()
            
        }
    }
    
    // MARK: - Private Methods
    
    private func updateViews(){
        let isRecording = fileOutput.isRecording
        recordButton.setTitle(isRecording ? "Stop" : "Record", for: .normal)
    }
    
    private func bestCamera() -> AVCaptureDevice {
        if let device = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) {
            return device
        }
        
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            return device
        }
        
        fatalError("Showhow were on a device that doesn't have a camera")
    }
    
    func defaultCamera() -> AVCaptureDevice? {
        if let device = AVCaptureDevice.default(.builtInDualCamera,
                                                for: AVMediaType.video,
                                                position: .back) {
            return device
        } else if let device = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                       for: AVMediaType.video,
                                                       position: .back) {
            return device
        } else {
            return nil
        }
    }
    
    private func newRecordingURL() -> URL {
        let fm = FileManager.default
        let documents = try! fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime]
        
        let name = f.string(from: Date())
        return documents.appendingPathComponent(name).appendingPathExtension("mov")
    }
    
    
    
    // MARK: - IBActions
    
    @IBAction func toggleRecording(_ sender: Any) {
        
        if fileOutput.isRecording {
            fileOutput.stopRecording()
            
        } else {
            let url = newRecordingURL()
            fileOutput.startRecording(to: url, recordingDelegate: self)
        }
    }
    
    private func saveVideo(with url: URL) {
        
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized else { return }
            PHPhotoLibrary.shared().performChanges({
                PHAssetCreationRequest.creationRequestForAssetFromVideo(atFileURL: url)
            }, completionHandler: { (success, error) in
                if let error = error {
                    NSLog("error saving photo: \(error)")
                } else {
                    NSLog("saving photo succeeded")
                }
            })
        }
    }
    
    private func authorization() {
        let authorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch authorizationStatus {
            
        case .notDetermined:
            // we have not asked the user yet for authorization
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted == false {
                    fatalError("Please don't do this in an actual app")
                }
                print("Permission Authorized")
            }
        case .restricted:
            // parental controls on the device prevent access to the cameras
            fatalError("Please have beter scenario handling than this")
        case .denied:
            // we asked for permission, but they said no
            fatalError("Please have beter scenario handling than this")
        case .authorized:
            // we asked for permission, and they said yes
            print("Permission Authorized")
        }
    }
    // AVPlayer - playback
    // this is playback but not visualization

    // AVPlayerLayer - like subclass of CameraPreviewLayer
    // set the

    // AVKit - provides a whole entire view controller
    // you can standard playback UI
    // simply by initializing one and setting a player property on it
    //

    // MARK: - Properties
    
    @IBOutlet weak var cameraView: CameraPreviewView!
    private let captureSession = AVCaptureSession()
    private let fileOutput = AVCaptureMovieFileOutput()
    @IBOutlet weak var recordButton: UIButton!
    
}
