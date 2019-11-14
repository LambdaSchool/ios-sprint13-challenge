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
    
    var media: Media?
    var delegate: ExperienceViewControllerDelegate?
    lazy private var captureSession = AVCaptureSession()
    lazy private var fileOutput = AVCaptureMovieFileOutput()
    
    var player: AVPlayer!
    @IBOutlet weak var cameraView: CameraPreviewView!
    @IBOutlet weak var recordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        setUpSession()
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
                tapGesture.numberOfTouchesRequired = 2 // Flip our camera
            
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
    }
    
    @objc func handleTapGesture(_ tapGesture: UITapGestureRecognizer) {
        print("handleTapGesture")
        
        switch tapGesture.state {
        case .ended:
            playRecording()
        default:
            print("Handle other states: \(tapGesture.state.rawValue)")
        }
    }
    
    @IBAction func recordButtonTapped(_ sender: UIButton) {
        if fileOutput.isRecording {
            // stop recording
            fileOutput.stopRecording()
            // TODO: play the video
        } else {
            // start recording
            let outputFileURL = newRecordingURL()
            fileOutput.startRecording(to: outputFileURL, recordingDelegate: self)
        }
    }
    
    private func playRecording() {
        if let player = player {
            player.seek(to: CMTime.zero)  // seek to the beginning of the video
            player.play()
        }
    }
    
    private func updateViews() {
        
    }
    
    private func setUpSession() {
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
    func newRecordingURL() -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        
        let name = formatter.string(from: Date())
        let fileURL = documentsDirectory.appendingPathComponent(name).appendingPathExtension("mov")
        return fileURL
    }
    
    private func playMovie(url: URL) {
        player = AVPlayer(url: url)
        
        // Create the layer
        
        let playerLayer = AVPlayerLayer(player: player)

        // Configure size
        var topCornerRect = self.view.bounds
        topCornerRect.size.width /= 4
        topCornerRect.size.height /= 4
        topCornerRect.origin.y = view.layoutMargins.top
        
        playerLayer.frame = topCornerRect
        self.view.layer.addSublayer(playerLayer)
        
        player.play()
        
        // video gravity
    }
}

extension VideoViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        
        if let error = error {
            print("File Recording Error: \(error)")
        }
        
        print("didFinishRecordingTo: \(outputFileURL)")
        
        playMovie(url: outputFileURL)
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        
        print("didStartRecordingTo: \(fileURL)")
    }
}
