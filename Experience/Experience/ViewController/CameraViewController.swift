//
//  CameraViewController.swift
//  Experience
//
//  Created by Lydia Zhang on 5/8/20.
//  Copyright © 2020 Lydia Zhang. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    
    @IBOutlet weak var cameraView: CameraPreviewView!
    @IBOutlet weak var RecordButton: UIButton!
    
    lazy private var captureSession = AVCaptureSession()
    lazy private var fileOutput = AVCaptureMovieFileOutput()
    private var player: AVPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraView.videoPlayerView.videoGravity = .resizeAspectFill
        setUpCaptureSession()
    }
    private func updateViews() {
        RecordButton.isSelected = fileOutput.isRecording
    }
    
    
    private func setUpCaptureSession() {
        // Add inputs
        captureSession.beginConfiguration()
        // Camera input
        let camera = bestCamera()
        
        guard let cameraInput = try? AVCaptureDeviceInput(device: camera),
            captureSession.canAddInput(cameraInput) else {
                fatalError("Error adding camera to capture session")
        }
        captureSession.addInput(cameraInput)
        
        if captureSession.canSetSessionPreset(.hd1920x1080) {
            captureSession.sessionPreset = .hd1920x1080
        }
        
        // Microphone input
        
        
        // Add outputs
        guard captureSession.canAddOutput(fileOutput) else {
            fatalError("Error: cannot save movie with capture session")
        }
        captureSession.addOutput(fileOutput)
        
        captureSession.commitConfiguration()
        cameraView.session = captureSession
        // TODO: Start/Stop session
    }
    
    private func bestCamera() -> AVCaptureDevice {
        // FUTURE: Toggle between front/back with a button
        
        // Ultra-wide lens (iPhone 11 Pro + Pro Max on back)
        if let ultraWideCamera = AVCaptureDevice.default(.builtInUltraWideCamera, for: .video, position: .back) {
            return ultraWideCamera
        }
        
        // Wide angle lens (available on any iPhone - front/back)
        if let wideAngleCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            return wideAngleCamera
        }
        
        // No cameras present (simulator)
        fatalError("No camera available - are you on a simulator?")
    }
    
    @IBAction func recordButtonTapped(_ sender: Any) {
        toggleRecord()
    }
    @IBAction func recordButtonPressedFromMenuBar(_ sender: Any) {
        toggleRecord()
    }
    
    private func toggleRecord() {
        if fileOutput.isRecording {
            fileOutput.stopRecording()
            navigationController?.popViewController(animated: true)
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
    
    private func playMovie(url: URL) {
            player = AVPlayer(url: url)
            
            let playerView = VideoPlayerView()
            playerView.player = player
            
            // top left corner (Fullscreen, you'd need a close button)
            var topRect = view.bounds
            topRect.size.height = topRect.size.height / 4
            topRect.size.width = topRect.size.width / 4 // create a constant for the "magic number"
            topRect.origin.y = view.layoutMargins.top
            playerView.frame = topRect
            view.addSubview(playerView) // FIXME: Don't add every time we play
            
            player.play()
    }
    

}
extension CameraViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let error = error {
            print("Error saving video: \(error)")
        } else {
            // show movie
            playMovie(url: outputFileURL)
        }
        
        updateViews()
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        print("startedRecording: \(fileURL)")
        updateViews()
    }
}
