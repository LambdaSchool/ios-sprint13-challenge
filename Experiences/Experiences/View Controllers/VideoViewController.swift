//
//  VideoViewController.swift
//  Experiences
//
//  Created by Lambda_School_Loaner_214 on 11/4/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import AVFoundation

class VideoViewController: UIViewController {
    
    //MARK: - Properties
    var media: Media?
    var delegate: ExperienceViewControllerDelegate?
    lazy private var captureSession = AVCaptureSession()
    lazy private var fileOutput = AVCaptureMovieFileOutput()
    private var player: AVPlayer!
    private var outputFileURL: URL!
    
    //MARK: - IBOutlets
    @IBOutlet weak var cameraView: CameraPreviewView!
    @IBOutlet weak var recordButton: UIButton!
    
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        //tapGesture.numberOfTouchesRequired = 2 // Flip our camera
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("Start capture session")
        captureSession.startRunning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        print("Stop capture session")
        captureSession.stopRunning()
        media = nil
    }
    
    //MARK: - IBActions
    @IBAction func recordButtonTapped(_ sender: UIButton) {
        if fileOutput.isRecording {
            // stop recording
            fileOutput.stopRecording()
            recordButton.setImage(UIImage(named: "Record"), for: .normal)
            // TODO: play the video
        } else {
            // start recording
            outputFileURL = newRecordingURL()
            recordButton.setImage(UIImage(named: "Stop"), for: .normal)
            fileOutput.startRecording(to: outputFileURL, recordingDelegate: self)
        }
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        guard let delegate = delegate else { return }
        if let media = self.media {
            if let url = outputFileURL {
                if media.mediaURL != url {
                    media.mediaURL = url
                    media.updatedDate = Date()
                }
            }
        } else {
            if let url = outputFileURL {
                delegate.mediaAdded(media: Media(mediaType: .video, url: url, data: nil, date: Date()))
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Private Functions
    
    private func updateViews() {
        if let media = media {
            self.recordButton.isHidden = true
            if let url = media.mediaURL {
                playMovie(url: url , small: false)
            }
        } else {
            setUpVideoSession()
        }
    }
    
    private func playRecording() {
        if let player = player {
            player.seek(to: CMTime.zero)  // seek to the beginning of the video
            player.play()
        }
    }
    
    @objc private func handleTapGesture(_ tapGesture: UITapGestureRecognizer) {
        print("handleTapGesture")
        
        switch tapGesture.state {
        case .ended:
            playRecording()
        default:
            print("Handle other states: \(tapGesture.state.rawValue)")
        }
    }
    
    private func setUpVideoSession() {
        captureSession.beginConfiguration()
        // Add the camera input
        let camera = bestBackCamera()
        guard let cameraInput = try? AVCaptureDeviceInput(device: camera) else {
            fatalError("Cannot create a device input from camera")
        }
        guard captureSession.canAddInput(cameraInput) else {
            fatalError("Cannot add camera to capture session")
        }
        captureSession.addInput(cameraInput)
        
        // Add audio input
        let microphone = bestAudio()
        guard let audioInput = try? AVCaptureDeviceInput(device: microphone) else {
            fatalError("Can't create input from microphone")
        }
        guard captureSession.canAddInput(audioInput) else {
            fatalError("Can't add audio input")
        }
        captureSession.addInput(audioInput)
        
        // Output (movie recording)
        guard captureSession.canAddOutput(fileOutput) else {
            fatalError("Cannot record video to a movie file")
        }
        captureSession.addOutput(fileOutput)
        captureSession.commitConfiguration()
        cameraView.session = captureSession
    }
    
    private func bestBackCamera() -> AVCaptureDevice {
        if let device = AVCaptureDevice.default(.builtInUltraWideCamera, for: .video, position: .back) {
            return device
        } else if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            return device
        }
        fatalError("ERROR: No cameras on the device or you are running on the Simulator")
    }
    
    private func bestFrontCamera() -> AVCaptureDevice {
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) {
            return device
        }
        fatalError("ERROR: No cameras on the device or you are running on the Simulator")
    }
    
    private func bestAudio() -> AVCaptureDevice {
        if let device = AVCaptureDevice.default(for: .audio) {
            return device
        }
        fatalError("ERROR: No audio device")
    }
    
    // Helper to save to documents directory
    private func newRecordingURL() -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        
        let name = formatter.string(from: Date())
        let fileURL = documentsDirectory.appendingPathComponent(name).appendingPathExtension("mov")
        return fileURL
    }
    
    private func playMovie(url: URL, small: Bool) {
        player = AVPlayer(url: url)
        
        // Create the layer
        let playerLayer = AVPlayerLayer(player: player)
        // Configure size
        switch small {
        case true:
            var topCornerRect = self.view.bounds
            topCornerRect.size.width /= 4
            topCornerRect.size.height /= 4
            topCornerRect.origin.y = view.layoutMargins.top
            playerLayer.frame = topCornerRect
        case false:
            self.navigationItem.rightBarButtonItem?.customView?.isHidden = true
            let fullScreenRect = self.view.bounds
//            fullScreenRect.size.width
//            fullScreenRect.size.height
//            fullScreenRect.origin.y = view.layoutMargins.top + 20
//            fullScreenRect.origin.x = view.layoutMargins.left + 20
            playerLayer.frame = fullScreenRect
        }
        self.view.layer.addSublayer(playerLayer)
        
        player.play()
    }
}

//MARK: - Extensions
extension VideoViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        
        if let error = error {
            print("File Recording Error: \(error)")
            return
        }
        
        print("didFinishRecordingTo: \(outputFileURL)")
        self.outputFileURL = outputFileURL
        playMovie(url: outputFileURL, small: true)
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        
        print("didStartRecordingTo: \(fileURL)")
    }
}
