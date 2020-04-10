//
//  VideoRecordingViewController.swift
//  Experiences
//
//  Created by Chris Gonzales on 4/10/20.
//  Copyright © 2020 Chris Gonzales. All rights reserved.
//

import UIKit
import AVFoundation

class VideoRecordingViewController: UIViewController, AVCaptureFileOutputRecordingDelegate {
    
    // MARK: - Properties
    
    var experienceController: ExperienceController?
    var geoTag: GeoTag?
    var descriptionText: String?
    
    private var player: AVPlayer!
    
    lazy private var captureSession = AVCaptureSession()
    lazy private var fileOutput = AVCaptureMovieFileOutput()
    
    // MARK: -  Outles
    
    @IBOutlet weak var cameraView: CameraPreviewView!
    @IBOutlet weak var recordButton: UIButton!
    
    // MARK: - Actions
    
    @IBAction func saveTapped(_ sender: Any) {
        guard let experienceController = experienceController,
            let geoTag = geoTag,
            let descriptionText = descriptionText else { return }
        let videoURL = newRecordingURL()
        experienceController.experience = Experience(description: descriptionText,
                                                     geoTag: geoTag,
                                                     audioComment: nil,
                                                     videoComment: videoURL,
                                                     photo: nil)
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func recordTapped(_ sender: UIButton) {
        if fileOutput.isRecording {
            fileOutput.stopRecording()
        } else {
            fileOutput.startRecording(to: newRecordingURL(), recordingDelegate: self)
        }
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        cameraView.videoPlayerView.videoGravity = .resizeAspectFill
        setUpCaptureSession()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        captureSession.startRunning()
    }
    
    // MARK: - Private Methods
    
    private func newRecordingURL() -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        
        let name = formatter.string(from: Date())
        let fileURL = documentsDirectory.appendingPathComponent(name).appendingPathExtension("mov")
        return fileURL
    }
    
    private func setUpCaptureSession() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [bestCamera().deviceType],
                                                                      mediaType: .video,
                                                                      position: .back)
        captureSession.beginConfiguration()
        
        guard let captureInput = try? AVCaptureDeviceInput(device: deviceDiscoverySession.devices.first!),
            captureSession.canAddInput(captureInput) else {
                fatalError("Cannot create  input from the camera")
        }
        captureSession.addInput(captureInput)
        
        if captureSession.canSetSessionPreset(.hd1920x1080) {
            captureSession.sessionPreset = .hd1920x1080
        }
        
        let microphone = bestAudio()
        guard let audioInput = try? AVCaptureDeviceInput(device: microphone),
            captureSession.canAddInput(audioInput) else {
                fatalError("Can't create microphone input")
        }
        captureSession.addInput(audioInput)
        guard captureSession.canAddOutput(fileOutput) else {
            fatalError("Cannot record to disk")
        }
        captureSession.addOutput(fileOutput)
        captureSession.commitConfiguration()
        
        cameraView.session = captureSession
    }
    
    private func bestCamera() -> AVCaptureDevice {
        if let ultraWideCamera = AVCaptureDevice.default(.builtInUltraWideCamera,
                                                         for: .video, position: .back) {
            return ultraWideCamera
        }
        if let wideCamera = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                    for: .video, position: .back) {
            return wideCamera
        }
        if let frontFacingCamera = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                           for: .video,
                                                           position: .front) {
            return frontFacingCamera
        }
        fatalError("No cameras on the device (or you're running this on a Simulator which isn't supported)")
    }
    
    private func bestAudio() -> AVCaptureDevice {
        if let device = AVCaptureDevice.default(for: .audio) {
            return device
        }
        fatalError("No audio")
    }
    
    private func replayVideoRecording() {
        guard let player = player else { return }
        player.seek(to: .zero)
        player.play()
    }
    
    // MARK: - Selector Methods
    
    @objc private func handleTapGesture(_ tapGesture: UITapGestureRecognizer) {
        print("tap")
        
        switch tapGesture.state {
        case .ended:
            replayVideoRecording()
        default:
            break
        }
    }
    
    // MARK: - Methods
    
    func playVideoRecording(url: URL) {
        player = AVPlayer(url: url)
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = cameraView.frame
        view.layer.addSublayer(playerLayer)
        
        player.play()
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        func fileOutput(_ output: AVCaptureFileOutput,
                        didFinishRecordingTo outputFileURL: URL,
                        from connections: [AVCaptureConnection],
                        error: Error?) {
            if let error = error {
                print("Video Recording Error: \(error)")
            } else {
                playVideoRecording(url: outputFileURL)
            }
        }
    }
}
