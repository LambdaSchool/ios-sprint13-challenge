//
//  AddVideoViewController.swift
//  Experiences
//
//  Created by Christopher Devito on 5/8/20.
//  Copyright © 2020 Christopher Devito. All rights reserved.
//

import UIKit
import AVFoundation

class AddVideoViewController: UIViewController {
    
    // MARK: - Properties
    var experienceController: ExperienceController?
    var name: String? {
        didSet {
            title = name
        }
    }
    var videoURL: URL?
    lazy private var captureSession = AVCaptureSession()
    lazy private var fileOutput = AVCaptureMovieFileOutput()
    private var player: AVPlayer!
    private let playerView = VideoPlayerView()
    private var videoLooper: AVPlayerLooper?
    
    // MARK: - IBOutlets
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var videoView: CameraPreviewView!
    
    // MARK: - IBActions
    @IBAction func recordVideo(_ sender: Any) {
        toggleRecord()
    }
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let name = name, let videoURL = videoURL else { fatalError() }
        experienceController?.addVideoToExperience(name: name, video: videoURL)
        performSegue(withIdentifier: "saveFullExperienceSegue", sender: self)
    }
    
    // MARK: - View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCaptureSession()
        videoView.videoPlayerView.videoGravity = .resizeAspectFill
        view.addSubview(playerView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        captureSession.startRunning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        captureSession.stopRunning()
    }
    
    func updateViews() {
        recordButton.isSelected = fileOutput.isRecording
    }
    
    // MARK: - Setup Methods
    
    private func setUpCaptureSession() {
        // Add inputs
        captureSession.beginConfiguration()
        let camera = bestCamera()
        
        guard let cameraInput = try? AVCaptureDeviceInput(device: camera), captureSession.canAddInput(cameraInput) else { fatalError() }
        captureSession.addInput(cameraInput)
        
        if captureSession.canSetSessionPreset(.hd1920x1080) {
            captureSession.sessionPreset = .hd1920x1080
        }
        
        let mic = getAudio()
        guard let audioInput = try? AVCaptureDeviceInput(device: mic), captureSession.canAddInput(audioInput) else { fatalError() }
        captureSession.addInput(audioInput)
        
        // Add outputs
        guard captureSession.canAddOutput(fileOutput) else { fatalError() }
        captureSession.addOutput(fileOutput)
        captureSession.commitConfiguration()
        
        videoView.session = captureSession
    }
    
    private func bestCamera() -> AVCaptureDevice {
        if let ultraWideCamera = AVCaptureDevice.default(.builtInUltraWideCamera, for: .video, position: .back) {
            return ultraWideCamera
        }
        if let wideAngleCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            return wideAngleCamera
        }
        
        fatalError("No camera available")
    }
    
    private func getAudio() -> AVCaptureDevice {
        if let mic = AVCaptureDevice.default(for: .audio) {
            return mic
        }
        fatalError("No Audio")
    }
    
    // MARK: - Action Methods
    private func toggleRecord() {
        if fileOutput.isRecording {
            fileOutput.stopRecording()
        } else {
            guard let name = name,
                let url = experienceController?.createNewVideoURL(name: name)
                else { return }
            fileOutput.startRecording(to: url, recordingDelegate: self)
        }
    }
    
    private func playMovie(url: URL) {
        let asset = AVAsset(url: url)
        let item = AVPlayerItem(asset: asset)
        let player = AVQueuePlayer(playerItem: item)
        playerView.player = player
        // top left corner (Fullscreen, you'd need a close button)
        var topRect = view.bounds
        topRect.size.height = topRect.size.height / 2
        topRect.size.width = topRect.size.width / 2 // create a constant for the "magic number"
        //topRect.origin.y = view.layoutMargins.top
        topRect.origin.y = view.bounds.height/2 - topRect.size.height/2
        topRect.origin.x = view.bounds.width/2 - topRect.size.width/2
        playerView.frame = topRect
        videoLooper = AVPlayerLooper(player: player, templateItem: item)
        player.play()
    }
}

extension AddVideoViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        updateViews()
        if let error = error {
            print("Error saving video: \(error)")
        } else {
            // show movie
            videoURL = outputFileURL
            playMovie(url: outputFileURL)
        }
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        print("Started Recording: \(fileURL)")
        updateViews()
        
    }
}
