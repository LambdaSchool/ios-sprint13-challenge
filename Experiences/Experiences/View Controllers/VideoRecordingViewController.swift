//
//  VideoRecordingViewController.swift
//  Experiences
//
//  Created by John Kouris on 1/25/20.
//  Copyright © 2020 John Kouris. All rights reserved.
//

import UIKit
import AVFoundation

class VideoRecordingViewController: UIViewController {
    
    lazy private var captureSession = AVCaptureSession()
    lazy private var fileOutput = AVCaptureMovieFileOutput()
    var player: AVPlayer!
    var outputFileURL: URL?
    
    @IBOutlet weak var cameraView: CameraPreviewView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var experience: Experience?
    var experienceController: ExperienceController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestPermissionAndShowCamera()
        
//        cameraView.videoPlayerView.videoGravity = .resizeAspectFill
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        captureSession.startRunning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        captureSession.stopRunning()
    }
    
    private func setUpCamera() {
        let camera = bestCamera()

        captureSession.beginConfiguration()
        guard let cameraInput = try? AVCaptureDeviceInput(device: camera) else {
            fatalError("Can't create an input from the camera, do something better than crashing")
        }

        guard captureSession.canAddInput(cameraInput) else {
            fatalError("This session can't handle this type of input: \(cameraInput)")
        }

        captureSession.addInput(cameraInput)

        if captureSession.canSetSessionPreset(.hd1920x1080) {
            captureSession.sessionPreset = .hd1920x1080
        }

        let microphone = bestAudio()
        guard let audioInput = try? AVCaptureDeviceInput(device: microphone) else {
            fatalError("Can't create input from microphone")
        }

        guard captureSession.canAddInput(audioInput) else {
            fatalError("Can't add audio input")
        }
        captureSession.addInput(audioInput)

        guard captureSession.canAddOutput(fileOutput) else {
            fatalError("Cannot record to disk")
        }
        captureSession.addOutput(fileOutput)

        captureSession.commitConfiguration()

//        cameraView.session = captureSession
    }
    
    private func toggleRecord() {
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
    
    private func bestCamera() -> AVCaptureDevice {
        if let device = AVCaptureDevice.default(.builtInUltraWideCamera, for: .video, position: .back) {
            return device
        }
        
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            return device
        }
        
        fatalError("No cameras on the device (or running it on the iPhone simulator)")
    }

    private func bestAudio() -> AVCaptureDevice {
        if let device = AVCaptureDevice.default(for: .audio) {
            return device
        }
        fatalError("No audio")
    }
    
    private func updateViews() {
        recordButton.isSelected = fileOutput.isRecording
    }
    
    @IBAction func recordButtonTapped(_ sender: Any) {
        toggleRecord()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
    }
    
    private func requestPermissionAndShowCamera() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .notDetermined:
            requestPermission()
        case .restricted:
            fatalError("Video is disabled for parental controls")
        case .denied:
            fatalError("Tell user they need to enable Privacy for Video/Camera/Microphone")
        case .authorized:
            showCamera()
        @unknown default:
            fatalError("A new status was added that we need to handle")
        }
    }
    
    private func requestPermission() {
        AVCaptureDevice.requestAccess(for: .video) { (granted) in
            guard granted else {
                fatalError("Tell user they need to enable Privacy for Video/Camera/Microphone")
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.showCamera()
            }
        }
    }
    
    private func showCamera() {
        setUpCamera()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension VideoRecordingViewController: AVCaptureFileOutputRecordingDelegate {
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        updateViews()
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let error = error {
            print("Error saving video: \(error)")
        }
        print("Video: \(outputFileURL.path)")
        self.outputFileURL = outputFileURL
        updateViews()
    }
    
}
