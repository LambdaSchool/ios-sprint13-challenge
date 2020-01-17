//
//  RecordMovieViewController.swift
//  MorseWeek13SprintChallenge
//
//  Created by morse on 1/17/20.
//  Copyright © 2020 morse. All rights reserved.
//

import UIKit
import AVFoundation

class RecordMovieViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var cameraView: CameraPreviewView!
    
    // MARK: - Properties
    
    var experienceController: ExperienceController?
    var experience: Experience?
    var video = ""
    lazy private var captureSession = AVCaptureSession()
    lazy private var fileOutput = AVCaptureMovieFileOutput()
    var experienceTitle: String?
    var latitude: Double?
    var longitude: Double?
    var audioExtension: String?
    var photoExtension: String?
    
//    var player: AVPlayer?
    
    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        cameraView.videoPlayerView.videoGravity = .resizeAspectFill
        setUpCamera()
        print(experienceController?.experiences, experience)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        captureSession.startRunning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        captureSession.stopRunning()
    }
    
    // MARK: - Actions
    
    @IBAction func recordTapped(_ sender: Any) {
        toggleRecording()
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        addVideo()
    }
    
    func addVideo() {
        
        guard let title = experienceTitle,
            let lat = latitude,
            let long = longitude else { return }
        
        experienceController?.createExperience(title: title, latitude: lat, longitude: long, videoExtension: video, audioExtension: audioExtension ?? "", photoExtension: photoExtension ?? "")
        navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - Methods
    
    func toggleRecording() {
        if fileOutput.isRecording {
            fileOutput.stopRecording()
        } else {
            fileOutput.startRecording(to: newRecordingURL(), recordingDelegate: self)
        }
    }
    
    private func setUpCamera() {
        let camera = bestCamera()
        captureSession.beginConfiguration()
        
        guard let cameraInput = try? AVCaptureDeviceInput(device: camera) else {
            fatalError("No video input")
        }
        guard captureSession.canAddInput(cameraInput) else {
            fatalError("Can't add video input")
        }
        captureSession.addInput(cameraInput)
        
        if captureSession.canSetSessionPreset(.hd1920x1080) {
            captureSession.canSetSessionPreset(.hd1920x1080)
        }
        
        let microphone = bestAudio()
        guard let audioInput = try? AVCaptureDeviceInput(device: microphone) else {
            fatalError("No audio input")
        }
        guard captureSession.canAddInput(audioInput) else {
            fatalError("Can't add audio input")
        }
        captureSession.addInput(audioInput)
        
        guard captureSession.canAddOutput(fileOutput) else {
            fatalError("Can't set up the file output")
        }
        captureSession.addOutput(fileOutput)
        
        captureSession.commitConfiguration()
        cameraView.session = captureSession
    }
    
    func newRecordingURL() -> URL {
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        video = UUID().uuidString
        print(video)
        let fileURL = documentsDirectory.appendingPathComponent(video).appendingPathExtension("mov")
        
        return fileURL
    }
    
    func bestCamera() -> AVCaptureDevice {
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            return device
        }
        fatalError("No camera")
    }
    
    private func bestAudio() -> AVCaptureDevice {
        if let device = AVCaptureDevice.default(for: .audio) {
            return device
        }
        fatalError("No audio")
    }
    
    func updateViews() {
        recordButton.isSelected = fileOutput.isRecording
    }
}

extension RecordMovieViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let error = error {
            print("Error recording: \(error)")
        }
        print(outputFileURL)
        updateViews()
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        updateViews()
    }
}
