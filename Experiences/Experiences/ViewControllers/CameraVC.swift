//
//  CameraVC.swift
//  Experiences
//
//  Created by Cora Jacobson on 11/7/20.
//

import UIKit
import AVFoundation
import AVKit

protocol VideoDelegate: AnyObject {
    func addVideo(url: URL)
}

class CameraVC: UIViewController {
    
    lazy private var captureSession = AVCaptureSession()
    lazy private var fileOutput = AVCaptureMovieFileOutput()
    lazy private var player = AVPlayer()
    private var playerView: VideoPlayerView!

    @IBOutlet private var playButton: UIButton!
    @IBOutlet private var recordButton: UIButton!
    @IBOutlet private var saveButton: UIButton!
    @IBOutlet private var cameraView: CameraPreviewView!
    
    var outputURL: URL?
    weak var delegate: VideoDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        requestPermissionForCamera()
        cameraView.videoPlayerLayer.videoGravity = .resizeAspectFill
        playButton.isHidden = true
        saveButton.isHidden = true
        setUpCamera()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        captureSession.startRunning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        captureSession.stopRunning()
    }
    
    func playMovie(url: URL) {
        player.replaceCurrentItem(with: AVPlayerItem(url: url))
        
        if playerView == nil {
            playerView = VideoPlayerView()
            playerView.player = player
            
            var topRect = view.bounds
            topRect.size.width  /= 4
            topRect.size.height  /= 4
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

    private func setUpCamera() {
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
    
    private var bestCamera: AVCaptureDevice {
        if let device = AVCaptureDevice.default(.builtInUltraWideCamera, for: .video, position: .back) {
            return device
        } else if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            return device
        }
        preconditionFailure("No cameras on device with specs that we need")
    }
    
    private var bestMicrophone: AVCaptureDevice {
        if let device = AVCaptureDevice.default(for: .audio) {
            return device
        }
        preconditionFailure("No microphones on device with specs that we need")
    }

    @IBAction func playButton(_ sender: UIButton) {
        guard let outputURL = outputURL else { return }
        playMovie(url: outputURL)
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        guard let outputUrl = outputURL else { return }
        delegate?.addVideo(url: outputUrl)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func recordButton(_ sender: UIButton) {
        if fileOutput.isRecording {
            fileOutput.stopRecording()
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
    
    private func updateViews() {
        recordButton.isSelected = fileOutput.isRecording
    }
    
    private func requestPermissionForCamera() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            requestVideoPermission()
        case .restricted:
            preconditionFailure("Video is disabled. Please review device restrictions.")
        case .denied:
            preconditionFailure("Tell the user they can't use the app without giving permission via Settings > Privacy > Video")
        case .authorized:
            break
        @unknown default:
            preconditionFailure("A new status code was added that we need to handle")
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

extension CameraVC: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        updateViews()
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let error = error {
            print("Error saving video: \(error)")
        }
        outputURL = outputFileURL
        playButton.isHidden = false
        saveButton.isHidden = false
        updateViews()
    }
}

