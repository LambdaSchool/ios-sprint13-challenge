//
//  VideoViewController.swift
//  Experiences
//
//  Created by denis cedeno on 5/15/20.
//  Copyright © 2020 DenCedeno Co. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class VideoViewController: UIViewController {
    
    var experience: Experience?
    var UUIDString: String = ""
    
    lazy private var captureSession = AVCaptureSession()
    lazy private var fileOutput = AVCaptureMovieFileOutput()
    
    private var player: AVPlayer!
    @IBOutlet var recordButton: UIButton!
    @IBOutlet var cameraView: CameraPreviewView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Resize camera preview to fill the entire screen
        cameraView.videoPlayerLayer.videoGravity = .resizeAspectFill
        setupCamera()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        view.addGestureRecognizer(tapGesture)
    
    }
    
    @objc func handleTapGesture(_ tapGesture: UITapGestureRecognizer) {
        switch tapGesture.state {
        case .ended:
            playRecording()
        default:
            print("Handled other tap states: \(tapGesture.state)")
        }
    }
    
    func playMovie(url: URL) {
        let playerVC = AVPlayerViewController()
        playerVC.player = AVPlayer(url: url)
        
        self.present(playerVC, animated: true, completion: nil)
    }
    
    func playRecording() {
        if let player = player {
            player.seek(to: CMTime(seconds: 0, preferredTimescale: 600)) // N/D, D = 600
            player.play()
        }
    }
    
    private func setupCamera() {
        let camera = bestCamera()
        let microphone = bestMicrophone()
        
        captureSession.beginConfiguration()
        
        guard let cameraInput = try? AVCaptureDeviceInput(device: camera) else {
            preconditionFailure("Can't create an input from the camera, but we should do something better than crashing!")
        }
        
        guard let microphoneInput = try? AVCaptureDeviceInput(device: microphone) else {
            preconditionFailure("Can't create an input from the microphone, but we should do something better than crashing!")
        }
        
        guard captureSession.canAddInput(cameraInput) else {
            preconditionFailure("This session can't handle this type of input: \(cameraInput)")
        }
        captureSession.addInput(cameraInput)
        
        guard captureSession.canAddInput(microphoneInput) else {
            preconditionFailure("This session can't handle this type of input: \(microphoneInput)")
        }
        captureSession.addInput(microphoneInput)
        
        if captureSession.canSetSessionPreset(.hd1920x1080) {
            captureSession.sessionPreset = .hd1920x1080
        }
        
        guard captureSession.canAddOutput(fileOutput) else {
            preconditionFailure("This session can't handle this type of output: \(fileOutput)")
        }
        captureSession.addOutput(fileOutput)
        
        captureSession.commitConfiguration()
        
        cameraView.session = captureSession
    }
    
    private func bestCamera() -> AVCaptureDevice {
        if let device = AVCaptureDevice.default(.builtInUltraWideCamera, for: .video, position: .back) {
            return device
        }
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            return device
        }
        
        preconditionFailure("No cameras on device match the specs that we need")
    }
    
    private func bestMicrophone() -> AVCaptureDevice {
        if let device = AVCaptureDevice.default(for: .audio) {
            return device
        }
        
        preconditionFailure("No microphones on device match the specs that we need")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        captureSession.startRunning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        captureSession.stopRunning()
    }
    
    @IBAction func recordButtonPressed(_ sender: Any) {
        if fileOutput.isRecording {
            fileOutput.stopRecording()
        } else {
            fileOutput.startRecording(to: newRecordingURL(), recordingDelegate: self)
        }
    }
    
    /// Creates a new file URL in the documents directory
    private func newRecordingURL() -> URL {

        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        
        let name = self.UUIDString
        let fileURL = documentsDirectory.appendingPathComponent(name).appendingPathExtension("mov")
//        let fileURL = documentsDirectory.appendingPathComponent(name).appendingPathExtension("mov")
        
        return fileURL
    }
    
    func updateViews() {
        recordButton.isSelected = fileOutput.isRecording
    }
}


extension VideoViewController: AVCaptureFileOutputRecordingDelegate {
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        updateViews()
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let error = error {
            print("Error saving video: \(error)")
        } else {
            print("Video URL: \(outputFileURL)")
        }
        
        
        updateViews()
        playMovie(url: outputFileURL)
    }
}

