//
//  VideoViewController.swift
//  ExperiencesSprint
//
//  Created by Jorge Alvarez on 3/13/20.
//  Copyright © 2020 Jorge Alvarez. All rights reserved.
//

import UIKit
import AVFoundation

class VideoViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var cameraView: CameraPreviewView!
    @IBOutlet weak var recordVideoButton: UIButton!
    
    // Add capture session
    lazy private var captureSession = AVCaptureSession()
    
    // Add movie output
    lazy private var fileOutput = AVCaptureMovieFileOutput() // allows you to save a .mov file

    var player: AVPlayer!
    var storedURL: URL?
    var experienceController: ExperienceController?
    
    // MARK: - Actions
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        
        let comment = masterExperienceController.comment ?? "N/A"
        let coordinate = currentLocation
        let image = masterExperienceController.image ?? UIImage(named: "tom")!
        let audioURL: URL = masterExperienceController.audioURL ?? URL(string: "audio")!
        let videoURL: URL = masterExperienceController.videoURL ?? URL(string: "video")!
        
        let newExp = Experience(comment: comment,
                                coordinate: coordinate,
                                image: image,
                                audioURL: audioURL,
                                videoURL: videoURL)
        masterExperienceController.experiences.append(newExp)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func recordVideoTapped(_ sender: UIButton) {
        toggleRecording()
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Resize camera preview to fill the entire screen
        cameraView.videoPlayerView.videoGravity = .resizeAspectFill
        setupCaptureSession()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        captureSession.startRunning()
    }
       
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        captureSession.stopRunning()
    }
       
    private func updateViews() {
        recordVideoButton.isSelected = fileOutput.isRecording
    }
    
    // MARK: - Video
    
    /// Checks to see if you're recording or not
    private func toggleRecording() {

        if fileOutput.isRecording {
            // Stop
            fileOutput.stopRecording()
            } else {
            // Start
            // Store URL
            storedURL = newRecordingURL()
            fileOutput.startRecording(to: storedURL!, recordingDelegate: self)
        }
    }
    
    /// Creates a new file URL in the documents directory
    private func newRecordingURL() -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]

        let name = formatter.string(from: Date())
        let fileURL = documentsDirectory.appendingPathComponent(name).appendingPathExtension("mov")
        return fileURL
    }
    
    private func setupCaptureSession() {
        let camera = bestCamera()
        
        // Open
        captureSession.beginConfiguration()
        
        // Add inputs
        guard let cameraInput = try? AVCaptureDeviceInput(device: camera), captureSession.canAddInput(cameraInput) else {
            fatalError("can't create camera with current input")
        }
        captureSession.addInput(cameraInput)
        
        // switch to 1080p or 4k video
        if captureSession.canSetSessionPreset(.hd1920x1080) {
            captureSession.sessionPreset = .hd1920x1080 // 1080p
        }
        
        // Add microphone
        let microphone = bestAudio()
        guard let audioInput = try? AVCaptureDeviceInput(device: microphone),
            captureSession.canAddInput(audioInput) else {
                fatalError("Can't create and add input from microphone")
        }
        captureSession.addInput(audioInput)
        
        
        // Add outputs
        guard captureSession.canAddOutput(fileOutput) else {
            fatalError("cannot save movie to capture session")
        }
        captureSession.addOutput(fileOutput)
        
        // Close
        captureSession.commitConfiguration()
        cameraView.session = captureSession
    }
    
    private func bestAudio() -> AVCaptureDevice {
        if let device = AVCaptureDevice.default(for: .audio) {
            return device
        }
        fatalError("No audio")
    }

    private func bestCamera() -> AVCaptureDevice {
        // ultra wide lens (0.5)
        if let device = AVCaptureDevice.default(.builtInUltraWideCamera, for: .video, position: .back) {
            return device
        }
        // wide angle lens (available on every single iPhone)
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            return device
        }
        
        // if none of these exist, we'll fatalError() (on simulator)
        fatalError("no cameras on device, or you're on the simualor")
        // Potentially the hardware is missing or broken (if the user serviced the device, or dropped in pool)
    }
}

// MARK: - Extensions

extension VideoViewController: AVCaptureFileOutputRecordingDelegate {
    // Apple done goofed
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        
        updateViews()
        
        if let error = error {
            print("Error recording video to :\(outputFileURL) : \(error)")
            return
        }
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        updateViews()
    }
}
