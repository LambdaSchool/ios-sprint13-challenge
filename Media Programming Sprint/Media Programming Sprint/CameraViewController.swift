//
//  CameraViewController.swift
//  Media Programming Sprint
//
//  Created by Lambda_School_Loaner_95 on 4/28/19.
//  Copyright © 2019 JS. All rights reserved.
//

import UIKit
import Photos
import AVFoundation


class CameraViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Setup the capture session
        
        // Inputs
        
        let camera = bestCamera()
        guard let cameraInput = try? AVCaptureDeviceInput(device: camera) else {
            fatalError("Can't create the input from the camera, do something else instead of crashing")
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
    
    var textTitle: String?
    
    // iOS 12.1.4 doesn't match iOS 12.2
    
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
        
        fatalError("No cameras on the device (or running in simulator), please try video on real device")
    }
    
    @IBAction func recordButtonPressed(_ sender: Any) {
        
        if fileOutput.isRecording {
            fileOutput.stopRecording()
            
            // Video file isn't finished saving yet ...
            recordButton.setTitle("Record", for: .normal)
        } else {
            // start a recording
            
            fileOutput.startRecording(to: newRecordingURL(), recordingDelegate: self)
            recordButton.setTitle("Stop", for: .normal)
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
    
    @IBOutlet weak var cameraView: CameraPreviewView!
   
    @IBOutlet weak var recordButton: UIButton!
    
    var experienceController: ExperienceController?
    
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "showMap", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMap" {
            let destinationVC = segue.destination as! ExperienceMapViewController
            
            destinationVC.experienceController = experienceController!
        }
    }
    
    lazy private var captureSession = AVCaptureSession()
    lazy private var fileOutput = AVCaptureMovieFileOutput()
}

extension CameraViewController: AVCaptureFileOutputRecordingDelegate {
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        
        PHPhotoLibrary.requestAuthorization { (status) in
            guard status == .authorized else {
                fatalError("Handle situation where user declines photo library access: Settings > Privacy")
            }
            
            PHPhotoLibrary.shared().performChanges({
                // Create request to save video
                
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
