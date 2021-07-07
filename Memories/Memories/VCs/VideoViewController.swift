//
//  VideoViewController.swift
//  Test
//
//  Created by Alexander Supe on 13.03.20.
//  Copyright © 2020 Alexander Supe. All rights reserved.
//

import UIKit
import AVFoundation

class VideoViewController: UIViewController {
    
    lazy private var captureSession = AVCaptureSession()
    lazy private var fileOutput = AVCaptureMovieFileOutput()
    
    @IBOutlet weak var cameraView: CameraPreviewView!
    @IBOutlet weak var recordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraView.videoPlayerView.videoGravity = .resizeAspectFill
        setupCaptureSession()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        captureSession.startRunning()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        captureSession.stopRunning()
    }
    private func setupCaptureSession() {
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else { return }
        captureSession.beginConfiguration()
            
            guard let cameraInput = try? AVCaptureDeviceInput(device: camera),
                captureSession.canAddInput(cameraInput) else { fatalError("Uncompatible input") }
            captureSession.addInput(cameraInput)
            
            if captureSession.canSetSessionPreset(.hd1920x1080) { captureSession.sessionPreset = .hd1920x1080 }
            
            let microphone = AVCaptureDevice.default(for: .audio)!
            guard let audioInput = try? AVCaptureDeviceInput(device: microphone),
                captureSession.canAddInput(audioInput) else {
                    fatalError("Can't create and add input from microphone")
            }
            captureSession.addInput(audioInput)
            
            guard captureSession.canAddOutput(fileOutput) else { fatalError("Cannot save movie") }
            captureSession.addOutput(fileOutput)
            
            captureSession.commitConfiguration()
            cameraView.session = captureSession
        }
    
    @IBAction func recordButtonPressed(_ sender: Any) {
        toggleRecording()
    }
    
    private func toggleRecording() {
        if fileOutput.isRecording { fileOutput.stopRecording() }
        else { fileOutput.startRecording(to: newURL(), recordingDelegate: self) }
    }
    
    private func newURL() -> URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let url = documents.appendingPathComponent(UUID().uuidString).appendingPathExtension("mov")
        UserDefaults.standard.set(url.lastPathComponent, forKey: "CurrentVideo")
        return url
    }
    
    private func updateViews() {
        recordButton.isSelected = fileOutput.isRecording
    }
}

extension VideoViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        updateViews()
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        updateViews()
    }
}

class CameraPreviewView: UIView {
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    var videoPlayerView: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
    
    var session: AVCaptureSession? {
        get { return videoPlayerView.session }
        set { videoPlayerView.session = newValue }
    }
}
