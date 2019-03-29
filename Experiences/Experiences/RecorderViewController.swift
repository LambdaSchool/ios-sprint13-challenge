//
//  RecorderViewController.swift
//  Experiences
//
//  Created by Julian A. Fordyce on 3/29/19.
//  Copyright © 2019 Julian A. Fordyce. All rights reserved.
//

import Foundation
import UIKit
import Photos
import AVFoundation



class RecorderViewController: UIViewController {
    
    
    override func viewDidLoad() {
        let camera = bestCamera()
        guard let cameraInput = try? AVCaptureDeviceInput(device: camera) else {
            fatalError("Can't create the input from the camera, do something else instead of crashing")
        }
        
        guard captureSession.canAddInput(cameraInput) else {
            fatalError("This session can't handle this type of input")
        }
        captureSession.addInput(cameraInput)
        
        guard captureSession.canAddOutput(fileOutput) else {
            fatalError("Cannot record to file")
        }
        captureSession.addOutput(fileOutput)
        
        
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
        
        fatalError("No cameras on the device (or running in simulator)")
    }
    
    @IBAction func recordVideo(_ sender: Any) {
        if fileOutput.isRecording {
            fileOutput.stopRecording()
        } else {
            fileOutput.startRecording(to: newRecordingURL(), recordingDelegate: self)
        }
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
        
        // MARK: - Properties
        
    lazy private var captureSession = AVCaptureSession()
    lazy private var fileOutput = AVCaptureMovieFileOutput()
    @IBOutlet weak var cameraView: CameraPreviewView!
    @IBOutlet weak var recordButton: UIButton!
    
    
}


extension RecorderViewController: AVCaptureFileOutputRecordingDelegate {
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        
        PHPhotoLibrary.requestAuthorization { (status) in
            guard status == .authorized else {
                fatalError("Handle situation where user declines photo library access: Settings > Privacy")
            }
            
            PHPhotoLibrary.shared().performChanges({
                PHAssetCreationRequest.creationRequestForAssetFromVideo(atFileURL: outputFileURL)
                
            }, completionHandler: { (success, error) in
                if let error = error {
                    print("Error saving video: \(error)")
                } else {
                    print("Saving video succeeded: \(outputFileURL)")
                }
            })
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
