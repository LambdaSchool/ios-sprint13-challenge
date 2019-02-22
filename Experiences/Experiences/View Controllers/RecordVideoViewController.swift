//
//  RecordVideoViewController.swift
//  Experiences
//
//  Created by Dillon McElhinney on 2/22/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import UIKit
import AVFoundation

protocol RecordVideoViewControllerDelegate: class {
    func recordVideoController(_ recordVideoController: RecordVideoViewController, didPostRecordingAt url: URL)
}

class RecordVideoViewController: UIViewController, AVCaptureFileOutputRecordingDelegate {

    // MARK: - Properties
    private let captureSession = AVCaptureSession()
    private let fileOutput = AVCaptureMovieFileOutput()
    private var currentURL: URL?
    private var playerView: VideoPlayerView?
    
    weak var delegate: RecordVideoViewControllerDelegate?
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var cameraPreviewView: CameraPreviewView!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSessionInputs()
        setupSessionOutputs()
        updateViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        captureSession.startRunning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        captureSession.stopRunning()
    }
    
    // MARK: - UI Actions
    @IBAction func recordVideo(_ sender: Any) {
        if let playerView = playerView {
            playerView.removeFromSuperview()
            self.playerView = nil
        }
        if fileOutput.isRecording {
            fileOutput.stopRecording()
        } else {
            fileOutput.startRecording(to: newRecordingURL(), recordingDelegate: self)
        }
    }
    
    @IBAction func postExperience(_ sender: Any) {
        if let currentURL = currentURL {
            delegate?.recordVideoController(self, didPostRecordingAt: currentURL)
        }
    }
    
    
    // MARK: - AV Capture File Output Recording Delegate
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        updateViews()
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        updateViews()
        currentURL = outputFileURL
        presentPlayerView(with: outputFileURL)
    }
    
    // MARK: - Private Methods
    private func backCamera() -> AVCaptureDevice? {
        if let device = AVCaptureDevice.default(.builtInDualCamera, for: AVMediaType.video, position: .back) {
            return device
        } else if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back) {
            return device
        }
        return nil
    }
    
    private func setupSessionInputs() {
        let camera = backCamera()
        guard let backCamera = camera, let cameraInput = try? AVCaptureDeviceInput(device: backCamera) else { fatalError("Can't create input from camera.") }
        guard captureSession.canAddInput(cameraInput) else { fatalError("Session can't add that input.") }
        
        captureSession.beginConfiguration()
        captureSession.addInput(cameraInput)
        
        if let microphone = AVCaptureDevice.default(for: .audio),
            let microphoneInput = try? AVCaptureDeviceInput(device: microphone),
            captureSession.canAddInput(microphoneInput) {
            captureSession.addInput(microphoneInput)
        }
        
        if captureSession.canSetSessionPreset(.medium) {
            captureSession.sessionPreset = .medium
        }
        captureSession.commitConfiguration()
        
        cameraPreviewView.viewPreviewLayer.videoGravity = .resizeAspectFill
        cameraPreviewView.session = captureSession
    }
    
    private func setupSessionOutputs() {
        guard captureSession.canAddOutput(fileOutput) else { return }
        captureSession.addOutput(fileOutput)
        return
    }
    
    private func newRecordingURL() -> URL {
        let documentDir = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        let name = ISO8601DateFormatter.string(from: Date(), timeZone: .current, formatOptions: [.withInternetDateTime])
        let fileURL = documentDir.appendingPathComponent(name).appendingPathExtension("mov")
        return fileURL
    }
    
    private func updateViews() {
        DispatchQueue.main.async {
            let isRecording = self.fileOutput.isRecording
            let recordTitle = isRecording ? "Stop" : "Record"
            self.recordButton.setTitle(recordTitle, for: .normal)
        }
    }
    
    private func presentPlayerView(with url: URL) {
        playerView = VideoPlayerView()
        view.insertSubview(playerView!, at: 1)
        playerView?.constrainToFill(view)
        
        let playerItem = AVPlayerItem(url: url)
        let player = AVPlayer(playerItem: playerItem)
        
        playerView?.viewPlayerLayer.videoGravity = .resizeAspectFill
        player.play()
        
        playerView?.player = player
        
    }
}
