//
//  CameraViewController.swift
//  Experiences
//
//  Created by Craig Belinfante on 11/8/20.
//  Copyright © 2020 Craig Belinfante. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class CameraViewController: UIViewController {
    
    var experienceController: ExperienceController?
    var fileTitle: String?
    var audioRecorder: AVAudioRecorder?
    
    lazy private var captureSession = AVCaptureSession()
    lazy private var fileOutput = AVCaptureMovieFileOutput()
    
    lazy private var player = AVPlayer()
    private var playerView: VideoPlayerView!
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet var cameraView: CameraPreviewView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraView.videoPlayerLayer.videoGravity = .resizeAspectFill
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
    
    func updateViews() {
        if fileOutput.isRecording {
            recordButton.setImage(UIImage(named: "Stop"), for: .normal)
        } else {
            recordButton.setImage(UIImage(named: "Record"), for: .normal)
        }
    }
    
    func playMovie(url: URL) {
        player.replaceCurrentItem(with: AVPlayerItem(url: url))
        
        if playerView == nil {
            playerView = VideoPlayerView()
            playerView.player = player
            
            var topRect = view.bounds
            topRect.size.width /= 4
            topRect.size.height /= 4
            topRect.origin.y = view.layoutMargins.top
            topRect.origin.x = view.bounds.size.width - topRect.size.width
            
            playerView.frame = topRect
            view.addSubview(playerView)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(playRecording(_:)))
            playerView.addGestureRecognizer(tapGesture)
        }
        
        player.play()
        
    }
    
    @IBAction func playRecording(_ sender: UITapGestureRecognizer) {
        guard sender.state == .ended else { return }
        
        let playerVC = AVPlayerViewController()
        playerVC.player = player
        
        self.present(playerVC, animated: true, completion: nil)
    }
    
    @IBAction func recordButtonPressed(_ sender: UIButton) {
        if fileOutput.isRecording {
            fileOutput.stopRecording()
        } else {
            fileOutput.startRecording(to: newRecordingURL(), recordingDelegate: self)
        }
    }
    
    private func setupCamera() {
        let camera = bestCamera
        let microphone = bestMicrophone
        
        captureSession.beginConfiguration()
        
        guard let cameraInput = try? AVCaptureDeviceInput(device: camera) else {
            preconditionFailure("Can't create an input from the camera.")
        }
        
        guard let microphoneInput = try? AVCaptureDeviceInput(device: microphone) else {
            preconditionFailure("Can't create an input from the microphone.")
        }
        
        guard captureSession.canAddInput(cameraInput) else {
            preconditionFailure("This session can't handle this type of camera input")
        }
        captureSession.addInput(cameraInput)
        
        guard captureSession.canAddInput(microphoneInput) else {
            preconditionFailure("This session can't handle this type of microphone input")
        }
        captureSession.addInput(microphoneInput)
        
        if captureSession.canSetSessionPreset(.hd1920x1080) {
            captureSession.sessionPreset = .hd1920x1080
        }
        
        guard captureSession.canAddOutput(fileOutput) else {
            preconditionFailure("This session can't handle this type of file output")
        }
        captureSession.addOutput(fileOutput)
        
        captureSession.commitConfiguration()
        
        cameraView.session = captureSession
    }
    
    private var bestCamera: AVCaptureDevice {
        if let device = AVCaptureDevice.default(.builtInUltraWideCamera, for: .video, position: .back) {
            return device
        } else if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            return device
        }
        
        preconditionFailure("No cameras on device match our specifications.")
    }
    
    private var bestMicrophone: AVCaptureDevice {
        if let device = AVCaptureDevice.default(for: .audio) {
            return device
        }
        
        preconditionFailure("No microphones on device match our specifications")
    }
    
    private func newRecordingURL() -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        
        let name = formatter.string(from: Date())
        let fileURL = documentsDirectory.appendingPathComponent(name).appendingPathExtension("mov")
        return fileURL
    }
    
    
}

extension CameraViewController: AVCaptureFileOutputRecordingDelegate {
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        DispatchQueue.main.async {
            self.updateViews()
        }
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        guard let currentLoaction = experienceController?.currentLocation, let fileTitle = fileTitle else {return}
        
        let experience = Experience(title: fileTitle, coordinate: currentLoaction)
        experience.video = String(outputFileURL.absoluteString)
        experienceController?.addNewExperience(newExperience: experience)
        dismiss(animated: true, completion: nil)
        
        playMovie(url: outputFileURL)
        updateViews()
    }
    
}
