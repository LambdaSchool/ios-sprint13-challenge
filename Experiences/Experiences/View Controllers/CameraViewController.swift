//
//  CameraViewController.swift
//  Experiences
//
//  Created by Dillon P on 3/22/20.
//  Copyright © 2020 Lambda iOSPT3. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    
    @IBOutlet weak var cameraView: CameraView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    
    lazy private var captureSession = AVCaptureSession()
    lazy private var fileOutput = AVCaptureMovieFileOutput()
    lazy private var playerLayer = AVPlayerLayer()
    
    var player: AVPlayer!
    var videoURL: URL? {
        didSet {
            do {
                videoData = try Data(contentsOf: videoURL!)
            } catch {
                print("Error converting video to data: \(error)")
            }
        }
    }
    
    // MARK: - Model Object Properties
    
    var imageData: Data?
    var audioData: Data?
    var videoData: Data?
    
    
    //MARK: - View Set-Up
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cameraView.videoPlayerLayer.videoGravity = .resizeAspectFill
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTapGesture(_ tapGesture: UITapGestureRecognizer) {
        if tapGesture.state == .ended {
//            replayRecording()
        }
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
        recordButton.isSelected = fileOutput.isRecording
    }
    
    
    // MARK: - Camera & Microphone Set-Up
    
    private func setUpCamera() {
        let camera = bestCamera()
        let microphone = bestMicrophone()
        
        captureSession.beginConfiguration()
        
        // Check if we have camer and mic available as inputs
        guard let cameraInput = try? AVCaptureDeviceInput(device: camera) else {
            preconditionFailure("Cannot get camera input")
        }
        guard let microphoneInput = try? AVCaptureDeviceInput(device: microphone) else {
            preconditionFailure("Cannot get microphone input")
        }
        
        // Add Video input
        guard captureSession.canAddInput(cameraInput) else {
            preconditionFailure("Unable to add camera input")
        }
        captureSession.addInput(cameraInput)
        
        // Add audio input
        guard captureSession.canAddInput(microphoneInput) else {
            preconditionFailure("Unable to add microphone input")
        }
        captureSession.addInput(microphoneInput)
        
        // Set video present
        if captureSession.canSetSessionPreset(.hd1920x1080) {
            captureSession.sessionPreset = .hd1920x1080
        }
        
        // Check if can output & add output
        guard captureSession.canAddOutput(fileOutput) else {
            preconditionFailure("Cannot write to disk")
        }
        captureSession.addOutput(fileOutput)
        
        captureSession.commitConfiguration()
        cameraView.session = captureSession
    }
    
    private func bestCamera() -> AVCaptureDevice {
        if let device = AVCaptureDevice.default(.builtInUltraWideCamera, for: .video, position: .back) {
            return device
        }
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            return device
        }
        preconditionFailure("No camera on device match the necessary specs for recording video")
    }
    
    private func bestMicrophone() -> AVCaptureDevice {
        if let device = AVCaptureDevice.default(for: .audio) {
            return device
        }
        preconditionFailure("No microphones on device could be used for recording video")
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
