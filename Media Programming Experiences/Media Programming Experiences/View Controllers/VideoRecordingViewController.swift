//
//  VideoRecordingViewController.swift
//  Media Programming Experiences
//
//  Created by Ivan Caldwell on 2/22/19.
//  Copyright © 2019 Ivan Caldwell. All rights reserved.
//

import UIKit
import AVFoundation

class VideoRecordingViewController: UIViewController, AVCaptureFileOutputRecordingDelegate {

    @IBOutlet weak var recordButton: UIButton!
    private let captureSession = AVCaptureSession()
    private let fileOutput = AVCaptureMovieFileOutput()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the capture session
        let camera = bestCamera()
        guard let cameraInput = try? AVCaptureDeviceInput(device: camera) else {
            fatalError("Can't create an input from the camera. Do something better than crashing")
        }
        
        guard captureSession.canAddInput(cameraInput) else {
            fatalError("This session can't handle this kind of input.")
        }
        
        captureSession.addInput(cameraInput)
        
        // Session Outputs
        guard captureSession.canAddOutput(fileOutput) else {
            fatalError("Cannont record to file.")
        }
        captureSession.addOutput(fileOutput)
        
        //By default the sessionPreset is .high, 4K is available ...
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
    
    @IBOutlet weak var cameraView: CameraView!
    @IBAction func toggleRecord(_ sender: Any) {
        if fileOutput.isRecording {
            fileOutput.stopRecording()
        } else {
            fileOutput.startRecording(to: newRecordingURL(), recordingDelegate: self)
        }
    }
    
    // MARK: - AVCaptureFileOutputRecordingDelegate
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        DispatchQueue.main.async {
            self.updateViews()
            // Save the moviefile to photo library
            PHPhotoLibrary.requestAuthorization { status in
                guard status == .authorized else { return }
                PHPhotoLibrary.shared().performChanges({
                    PHAssetCreationRequest.creationRequestForAssetFromVideo(atFileURL: outputFileURL)
                }, completionHandler: { (success, error) in
                    if let error = error {
                        NSLog("error saving video: \(error)")
                    } else {
                        NSLog("saving video succeeded")
                    }
                })
            }
        }
    }
    
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        DispatchQueue.main.async {
            self.updateViews()
        }
    }
    
    
    
    
    // MARK: - Private Methods
    private func bestCamera() -> AVCaptureDevice {
        // We selecting which camera we want to use
        if let device = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) {
            return device
        }
        
        // All Apple device with cameras have a wideAngleCamera
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            return device
        }
        fatalError("Shomehow we're on a device that doesn't have a camera.")
    }
    
    private func newRecordingURL() -> URL {
        let fm = FileManager.default
        let documents = try! fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime]
        
        let name = f.string(from: Date())
        return documents.appendingPathComponent(name).appendingPathExtension("mov")
    }
    
    private func updateViews() {
        let isRecording = fileOutput.isRecording
        recordButton.setTitle(isRecording ? "Stop" : "Record", for: .normal)
    }
}
