//
//  VideoRecordingManager.swift
//  Experiences
//
//  Created by Chad Rutherford on 2/16/20.
//  Copyright © 2020 Chad Rutherford. All rights reserved.
//

import AVFoundation
import Foundation

class VideoRecordingManager {
    func requestPermissionAndShowCamera(completion: @escaping (Bool) -> Void) {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .notDetermined:
            self.requestVideoPermission(completion: completion)
        case .restricted:
            fatalError("Parental controls have been enabled. Video access is denied.")
        case .denied:
            fatalError("Tell User to enable permission for Video/Camera")
        case .authorized:
            completion(true)
        @unknown default:
            fatalError("Apple added a new case for status that we aren't handling yet.")
        }
    }
    
    private func requestVideoPermission(completion: @escaping (Bool) -> Void = { _ in }) {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            guard granted else {
                fatalError("Tell User to enable permission for Video/Camera")
            }
            DispatchQueue.main.async { completion(true) }
        }
    }
    
    func setupCamera(with view: CameraPreviewView, and session: AVCaptureSession, and fileOutput: AVCaptureMovieFileOutput) {
        
        // Creating the camera for use
        let camera = bestCamera()
        
        // Starting video configuration
        session.beginConfiguration()
        
        // Inputs
        guard let cameraInput = try? AVCaptureDeviceInput(device: camera) else { fatalError("Device configured incorrectly") }
        guard session.canAddInput(cameraInput) else { fatalError("Unable to add camera input") }
        session.addInput(cameraInput)
        
        // Resolution
        if session.canSetSessionPreset(.hd1920x1080) {
            session.sessionPreset = .hd1920x1080
        }
        
        // Microphone
        let microphone = bestAudio()
        guard let audioInput = try? AVCaptureDeviceInput(device: microphone) else { fatalError("Device configured incorrectly") }
        guard session.canAddInput(audioInput) else { fatalError("Unable to add audio input") }
        session.addInput(audioInput)
        
        // Outputs
        guard session.canAddOutput(fileOutput) else { fatalError("Cannot add file output") }
        session.addOutput(fileOutput)
        
        // We have reached the end and need to save the configuration to create a file
        session.commitConfiguration()
        view.session = session
    }
    
    private func bestCamera() -> AVCaptureDevice {
        if let device = AVCaptureDevice.default(.builtInUltraWideCamera, for: .video, position: .back) {
            return device
        }
        
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            return device
        }
        
        fatalError("No cameras available on device (or running in the Simulator)")
        
    }
    
    private func bestAudio() -> AVCaptureDevice {
        if let device = AVCaptureDevice.default(for: .audio) {
            return device
        }
        fatalError()
    }
}
