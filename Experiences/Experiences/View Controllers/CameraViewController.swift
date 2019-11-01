//
//  CameraViewController.swift
//  Experiences
//
//  Created by Jake Connerly on 11/1/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation

class CameraViewController: UIViewController {
    
    @IBOutlet weak var cameraView: CameraPreviewView!
    @IBOutlet weak var recordButton: UIButton!
    
    var experienceController: ExperienceController?
    var imageToSave: Data?
    var audioToSave: String?
    var videoToSave: String?
    var experienceTitle: String?
    var currentLocation: CLLocationCoordinate2D?
    
    lazy private var captureSession = AVCaptureSession()
    lazy private var fileOutput = AVCaptureMovieFileOutput()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("Start capture session")
        captureSession.startRunning()
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
        
        
        // Set video mode
        if captureSession.canSetSessionPreset(.hd4K3840x2160) {
            captureSession.sessionPreset = .hd4K3840x2160
            print("4K support!!!")
        }
        
        // Add the audio input
        // Add audio input
        let microphone = bestAudio()
        guard let audioInput = try? AVCaptureDeviceInput(device: microphone) else {
            fatalError("Can't create input from microphone")
        }
        guard captureSession.canAddInput(audioInput) else {
            fatalError("Can't add audio input")
        }
        captureSession.addInput(audioInput)
        
        // TODO: Add recording
        guard captureSession.canAddOutput(fileOutput) else {
            fatalError("Cannot record video to a movie file")
        }
        captureSession.addOutput(fileOutput)
        
        
        captureSession.commitConfiguration()
        
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
    
    func newRecordingURL() -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        
        let name = formatter.string(from: Date())
        let fileURL = documentsDirectory.appendingPathComponent(name).appendingPathExtension("mov")
        
        return fileURL
    }
    
    @IBAction func recordButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let experienceController = experienceController,
            let title = experienceTitle,
            let audio = audioToSave,
            let image = imageToSave,
            let currentLocation = currentLocation else { return }
        
        experienceController.createExperience(with: title, image: image, audioCommentURL: audio, geotag: currentLocation)
        
        navigationController?.popToRootViewController(animated: true)
    }
}

extension CameraViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let error = error {
            print("File recording error: \(error)")
        }
        print("didFinishRecordingTo: \(outputFileURL)")
        
        videoToSave = "\(outputFileURL)"
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
    }
}
