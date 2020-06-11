//
//  CameraViewController.swift
//  Car Trek
//
//  Created by Christy Hicks on 6/7/20.
//  Copyright © 2020 Knight Night. All rights reserved.
//


import UIKit
import AVFoundation
import AVKit

class CameraViewController: UIViewController {
    // MARK: - Properties
    // General
    var visit: Visit? {
        didSet {
            videoURL = visit?.videoRecordingURL
        }
    }
    
    var cameraDelegate: CameraDelegate?
    
    // Record
    lazy private var captureSession = AVCaptureSession()
    lazy private var fileOutput = AVCaptureMovieFileOutput()
    
    // Playback
    var videoURL: URL?
    var player: AVPlayer!
    
    // Outlets
    @IBOutlet var recordButton: UIButton!
    @IBOutlet var cameraView: CameraPreviewView!
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
    
        cameraView.videoPlayerLayer.videoGravity = .resizeAspectFill
        setupCamera()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        captureSession.startRunning()
   
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        captureSession.stopRunning()
    }
    
    func updateViews() {
        recordButton.isSelected = fileOutput.isRecording
        if let videoURL = visit?.videoRecordingURL {
            playMovie(url: videoURL)
        }
    }
    
    // MARK: - Actions
    @IBAction func handleTapGesture(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            playRecording()
        }
    }
    
    @IBAction func recordButtonPressed(_ sender: Any) {
        if fileOutput.isRecording {
            fileOutput.stopRecording()
        } else {
            fileOutput.startRecording(to: newRecordingURL(), recordingDelegate: self)
        }
    }
    
    // MARK: - Methods
    // Record
    private func setupCamera() {
        let camera = bestCamera()
        let microphone = bestMicrophone()
        
        captureSession.beginConfiguration()
        
        guard let cameraInput = try? AVCaptureDeviceInput(device: camera) else {
            preconditionFailure("Can't create an input from the camera. ")
        }
        
        guard let microphoneInput = try? AVCaptureDeviceInput(device: microphone) else {
            preconditionFailure("Can't create an input from the microphone.")
        }
        
        guard captureSession.canAddInput(cameraInput) else {
            preconditionFailure("This session can't handle this type of input: \(cameraInput)")
        }
        
        captureSession.addInput(cameraInput)
        captureSession.addInput(microphoneInput)
        
        if captureSession.canSetSessionPreset(.hd1920x1080) {
            captureSession.sessionPreset = .hd1920x1080
        }
        
        guard captureSession.canAddOutput(fileOutput) else {
            preconditionFailure("This session can't handle this type of output.")
        }
        
        captureSession.addOutput(fileOutput)
        captureSession.commitConfiguration()
        cameraView.session = captureSession
    }
    
    private func bestCamera() -> AVCaptureDevice {
        if let device = AVCaptureDevice.default(.builtInUltraWideCamera,for: .video, position: .back) {
            return device
        }
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            return device;
        }
        preconditionFailure("No cameras on device match the specs that we need.")
    }
    
    private func bestMicrophone() -> AVCaptureDevice {
        if let device = AVCaptureDevice.default(for: .audio) {
            return device
        }
        
        preconditionFailure("No microphones on device match the specs that we need.")
    }
    
    private func newRecordingURL() -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        
        let name = formatter.string(from: Date())
        let fileURL = documentsDirectory.appendingPathComponent(name).appendingPathExtension("mov")
        visit?.videoRecordingURL = fileURL
        return fileURL
    }
    
    // Playback
    func playRecording() {
        if let player = player {
            player.seek(to: CMTime(seconds: 0, preferredTimescale: 600))
            player.play()
        }
    }
    
    func playMovie(url: URL) {
        let playerVC = AVPlayerViewController()
        playerVC.player = AVPlayer(url: url)
        
        self.present(playerVC, animated: true, completion: nil)
    }
}


// MARK: - Delegates
protocol CameraDelegate {
    func saveURL(url: URL)
}

extension CameraViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let error = error {
            print("Error saving video: \(error)")
        }
        
        videoURL = outputFileURL
        cameraDelegate?.saveURL(url: outputFileURL)
        updateViews()
        playMovie(url: outputFileURL)
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        updateViews()
    }
}
