//
//  RecordVideoViewController.swift
//  Experiences
//
//  Created by Wyatt Harrell on 5/8/20.
//  Copyright © 2020 Wyatt Harrell. All rights reserved.
//

import UIKit
import AVFoundation

protocol RecordedVideoURLDelegate: AnyObject {
    func recordedVideoURL(url: URL)
}

class RecordVideoViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var cameraView: CameraPreviewView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    // MARK: - Properties
    lazy private var captureSession = AVCaptureSession()
    lazy private var fileOutput = AVCaptureMovieFileOutput()
    var recordedVideoURL: URL?
    weak var delegate: RecordedVideoURLDelegate?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        captureSession.startRunning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        captureSession.stopRunning()
    }
    
    // MARK: - Private Methods
    private func setupViews() {
        cameraView.videoPlayerView.videoGravity = .resizeAspectFill
        setUpCaptureSession()
    }
    
    private func updateViews() {
        recordButton.isSelected = fileOutput.isRecording
        if fileOutput.isRecording {
            cancelButton.isEnabled = false
        } else {
            cancelButton.isEnabled = true
        }
    }
    
    private func setUpCaptureSession() {
        captureSession.beginConfiguration()
        let camera = bestCamera()
        
        guard let cameraInput = try? AVCaptureDeviceInput(device: camera),
                                     captureSession.canAddInput(cameraInput) else {
            fatalError("Error adding camera to capture session")
        }
        
        captureSession.addInput(cameraInput)
        
        if captureSession.canSetSessionPreset(.hd1920x1080) {
            captureSession.sessionPreset = .hd1920x1080
        }

        guard captureSession.canAddOutput(fileOutput) else {
            fatalError("Error: Cannot save movie")
        }
        captureSession.addOutput(fileOutput)
        
        captureSession.commitConfiguration()
        cameraView.session = captureSession
    }
    
    private func bestCamera() -> AVCaptureDevice {
        if let ultraWideCamera = AVCaptureDevice.default(.builtInUltraWideCamera, for: .video, position: .back) {
            return ultraWideCamera
        }

        if let wideAngleCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            return wideAngleCamera
        }
        
        fatalError("No camera available - are you on a simulator?")
    }
    
    private func toggleRecord() {
        if fileOutput.isRecording {
            fileOutput.stopRecording()
        } else {
            recordedVideoURL = newRecordingURL()
            fileOutput.startRecording(to: recordedVideoURL!, recordingDelegate: self)
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
    
    // MARK: - IBActions
    @IBAction func recordButtonTapped(_ sender: Any) {
        toggleRecord()
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension RecordVideoViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let error = error {
            print("Error saving video: \(error)")
        } else {
            delegate?.recordedVideoURL(url: outputFileURL)
            print("Video Recorded. Passing URL: \(outputFileURL)")
            dismiss(animated: true, completion: nil)
        }
        updateViews()
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        print("started recording \(fileURL)")
        updateViews()
    }
}
