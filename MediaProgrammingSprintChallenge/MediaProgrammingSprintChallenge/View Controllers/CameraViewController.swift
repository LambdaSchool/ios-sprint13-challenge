//
//  CameraViewController.swift
//  MediaProgrammingSprintChallenge
//
//  Created by Nathanael Youngren on 3/29/19.
//  Copyright © 2019 Nathanael Youngren. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class CameraViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up the capture session
        
        let camera = bestCamera()
        
        // Inputs
        
        guard let cameraInput = try? AVCaptureDeviceInput(device: camera) else {
            fatalError("Can't create the input from camera, do something else")
        }
        
        guard captureSession.canAddInput(cameraInput) else {
            fatalError("This session can't handle this type of input")
        }
        
        captureSession.addInput(cameraInput)
        
        // Outputs
        guard captureSession.canAddOutput(fileOutput) else {
            fatalError("Cannot record to file")
        }
        
        captureSession.addOutput(fileOutput)
        
        // Settings
        
        if captureSession.canSetSessionPreset(.hd1920x1080) {
            captureSession.canSetSessionPreset(.hd1920x1080)
        }
        
        captureSession.commitConfiguration()
        
        cameraView.session = captureSession
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        captureSession.startRunning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        captureSession.stopRunning()
    }
    
    private func bestCamera() -> AVCaptureDevice {
        if let device = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) {
            return device
        }
        
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            return device
        }
        
        fatalError()
    }
    
    private func newRecordingURL() -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        
        let name = formatter.string(from: Date())
        let fileURL = documentsDirectory.appendingPathComponent(name).appendingPathExtension("mov")
        return fileURL
    }
    
    private func updateViews() {
        recordButton.isSelected = fileOutput.isRecording
    }
    
    @IBAction func recordButtonTapped(_ sender: UIButton) {
        
        if fileOutput.isRecording {
            fileOutput.stopRecording()
        } else {
            fileOutput.startRecording(to: newRecordingURL(), recordingDelegate: self)
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let audioURL = audioURL, let imageURL = imageURL, let caption = caption,
        let longitude = longitude, let latitude = latitude,
        let videoURL = fileOutput.outputFileURL
        else { return }
        
        momentController?.createMoment(caption: caption, imageURL: imageURL, audioURL: audioURL, videoURL: videoURL, longitude: longitude, latitude: latitude)
    }
    
    var audioURL: URL?
    var imageURL: URL?
    var caption: String?
    var longitude: Double?
    var latitude: Double?
    
    @IBOutlet weak var cameraView: CameraView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var momentController: MomentController?
    
    lazy private var captureSession = AVCaptureSession()
    lazy private var fileOutput = AVCaptureMovieFileOutput()
    
    
}

extension CameraViewController: AVCaptureFileOutputRecordingDelegate {
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        
        PHPhotoLibrary.requestAuthorization { (status) in
            guard status == .authorized else {
                fatalError()
            }
        }
        
        PHPhotoLibrary.shared().performChanges({
            
            PHAssetCreationRequest.creationRequestForAssetFromVideo(atFileURL: outputFileURL)
            
        }) { (success, error) in
            if error != nil {
                print("Error saving video")
            } else {
                print("Saving video succeeded")
            }
        }
        
        DispatchQueue.main.async {
            self.updateViews()
        }
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        DispatchQueue.main.async {
            self.updateViews()
        }
    }
}
