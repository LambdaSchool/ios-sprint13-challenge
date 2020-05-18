//
//  AddVideoViewController.swift
//  Experiences
//
//  Created by David Wright on 5/17/20.
//  Copyright © 2020 David Wright. All rights reserved.
//

import UIKit
import AVKit

class AddVideoViewController: UIViewController {

    // MARK: - Properties

    lazy private var captureSession = AVCaptureSession()
    lazy private var fileOutput = AVCaptureMovieFileOutput()
    
    private var player: AVPlayer!
    private var videoURL: URL?
    var delegate: AddMediaViewControllerDelegate?
    
    // MARK: - IBOutlets
    
    @IBOutlet var recordButton: UIButton!
    @IBOutlet var cameraView: CameraPreviewView!
    @IBOutlet weak var moviePlayerView: MoviePlayerView!
    
    // MARK: - View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        requestPermissionAndShowCamera()
        
        moviePlayerView.videoPlayerLayer.videoGravity = .resizeAspect
        cameraView.videoPlayerLayer.videoGravity = .resizeAspect
        setupCamera()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        captureSession.startRunning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        captureSession.stopRunning()
    }
    
    // MARK: - IBActions

    @IBAction func recordButtonPressed(_ sender: UIButton) {
        if fileOutput.isRecording {
            fileOutput.stopRecording()
        } else {
            videoURL = MediaFile.newURL(forType: .video)
            fileOutput.startRecording(to: videoURL!, recordingDelegate: self)
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let videoURL = videoURL else { return }
        
        moviePlayerView.player?.pause()
        moviePlayerView.player = nil
        delegate?.didSaveMedia(mediaType: .video, to: videoURL)
        
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Update Views
    
    private func updateViews() {
        recordButton.isSelected = fileOutput.isRecording
    }
    
    // MARK: - Video Playback
    
    private func playMovie(url: URL) {
        player = AVPlayer(url: url)
        
        moviePlayerView.player = player

        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                                               object: self.player.currentItem,
                                               queue: .main) { [weak self] _ in
                                                self?.replayMovie()
        }
        
        player.play()
    }
    
    private func replayMovie() {
        guard let player = player else { return }
        
        player.seek(to: .zero)
        player.play()
    }
    
    // MARK: - Setup Methods
    
    private func setupCamera() {
        let camera = bestCamera()
        let microphone = bestMicrophone()
        
        captureSession.beginConfiguration()
        
        // MARK: - Begin Configuring Capture Session
        
        // Add input: Video
        guard let cameraInput = try? AVCaptureDeviceInput(device: camera) else {
            preconditionFailure("Can't create an input from the camera, but we should do something better than crashing!")
        }
        
        guard captureSession.canAddInput(cameraInput) else {
            preconditionFailure("This session can't handle this type of input: \(cameraInput)")
        }
        
        captureSession.addInput(cameraInput)
        
        if captureSession.canSetSessionPreset(.hd1920x1080) {
            captureSession.sessionPreset = .hd1920x1080
        }
        
        // Add input: Audio
        guard let microphoneInput = try? AVCaptureDeviceInput(device: microphone) else {
            preconditionFailure("Can't create an input from the microphone, but we should do something better than crashing!")
        }
        
        guard captureSession.canAddInput(microphoneInput) else {
            preconditionFailure("This session can't handle this type of input: \(microphoneInput)")
        }
        
        captureSession.addInput(microphoneInput)
        
        // Add output: Recording to disk
        guard captureSession.canAddOutput(fileOutput) else {
            preconditionFailure("This session can't handle this type of output: \(fileOutput)")
        }
        
        captureSession.addOutput(fileOutput)
        
        // MARK: - End Configuring Capture Session
        
        captureSession.commitConfiguration()
        
        cameraView.session = captureSession // Live preview
    }
    
    private func bestCamera() -> AVCaptureDevice {
        
        // All iPhones have a wide angle camera (front + back)
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            return device
        }
        
        // TODO: Add a button to toggle front/back camera
        
        preconditionFailure("No cameras on device match the specs that we need (or you're running this on a Simulator which isn't supported)")
    }
    
    private func bestMicrophone() -> AVCaptureDevice {
        if let device = AVCaptureDevice.default(for: .audio) {
            return device
        }
        
        preconditionFailure("No microphones on device match the specs that we need")
    }
}

// MARK: - AVCaptureFileOutput Recording Delegate

extension AddVideoViewController: AVCaptureFileOutputRecordingDelegate {
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        updateViews()
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let error = error {
            print("Error saving video: \(error)")
        }
        
        updateViews()
        
        playMovie(url: outputFileURL)
    }
}

extension AddVideoViewController {
    
    private func requestPermissionAndShowCamera() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            
        case .notDetermined: // 1st run and the user hasn't been asked to give permission
            requestVideoPermission()
            
        case .restricted: // Parental controls, for instance, are preventing recording
            preconditionFailure("Video is disabled, please review device restrictions")
            
        case .denied: // 2nd+ run, the user didn't trust us, or they said no by accident (show how to enable)
            preconditionFailure("Tell the user they can't use the app without giving permissions via Settings > Privacy > Video")
            
        case .authorized: // 2nd+ run, the user has given the app permission to use the camera
            break
        
        @unknown default:
            preconditionFailure("A new status code for AVCaptureDevice authorization was added that we need to handle")
        }
    }

    private func requestVideoPermission() {
        AVCaptureDevice.requestAccess(for: .video) { isGranted in
            guard isGranted else {
                preconditionFailure("UI: Tell the user to enable permissions for Video/Camera")
            }
        }
    }
}
