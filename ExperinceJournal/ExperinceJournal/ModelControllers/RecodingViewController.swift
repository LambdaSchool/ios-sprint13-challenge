//
//  RecodingViewController.swift
//  ExperinceJournal
//
//  Created by Lambda_School_Loaner_218 on 2/16/20.
//  Copyright © 2020 Lambda_School_Loaner_218. All rights reserved.
//

protocol VideoViewControllerDelegate {
    func addVideoButtonTapped()
}
import UIKit
import AVFoundation
class RecodingViewController: UIViewController {
    
    
    var player: AVPlayer!
    lazy private var captureSession = AVCaptureSession()
    lazy private var fileOutput = AVCaptureMovieFileOutput()
    var delegate: VideoViewControllerDelegate?
    var isRecording: Bool {
              fileOutput.isRecording
          }
   
    
   @IBOutlet weak var recordButton: UIButton!
   @IBOutlet weak var cameraView: CameraPreviewView!
    
    
    
    @IBAction func addVideoExperienceButtonTapped(_ sender: Any) {
         
    }
    
    @IBAction func recordButtonTapped(_ sender: Any) {
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Resize camera preview to fill the entire screen
        cameraView.videoPlayerView.videoGravity = .resizeAspectFill
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
        
        
        
    
    
    private func setUpCamera() {
        let camera = bestCamera()
        
        
        // configuration
        
        captureSession.beginConfiguration()
        
        // Inputs
        
        guard let cameraInput = try? AVCaptureDeviceInput(device: camera) else {
            fatalError("Device configured incorrectly")
        }
        
        guard captureSession.canAddInput(cameraInput) else {
            fatalError("Unable to add camera input")
            
        }
        
        captureSession.addInput(cameraInput)
        
        
        // 1920x1080p
        
        if captureSession.canSetSessionPreset(.hd1920x1080) {
            captureSession.sessionPreset = .hd1920x1080
        }
        
        // Microphone
        
        
        
        
        // Outputs
        guard captureSession.canAddOutput(fileOutput) else {
            fatalError("Cannot add file output")
        }
        
        captureSession.addOutput(fileOutput)
        
        
        
        
        
        // commit configuration
        
        captureSession.commitConfiguration()
        
        cameraView.session = captureSession
        
        
    }
    private func bestCamera() -> AVCaptureDevice {
        // front / back
        // wide angle, ultra wide angle, depth, zoom lens
        // try ultra wide lens
        if let device = AVCaptureDevice.default(.builtInUltraWideCamera, for: .video, position: .back) {
            return device
        }
        // try wide angle lens
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            return device
        }
        fatalError("No cameras available on the device (or you're using a simulator)")
    }
    @IBAction func recordButtonPressed(_ sender: Any) {
        toggleRecord()
      
    }
    
    func toggleRecord() {
        if isRecording {
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
    
    func playVideo(url: URL) {
        player = AVPlayer(url: url)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = cameraView.frame
        playerLayer.videoGravity = .resize
        view.layer.addSublayer(playerLayer)
        player?.play()
    }
    
    
    private func updateViews() {
        recordButton.isSelected = isRecording
    }
}
extension RecodingViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        updateViews()
       
        
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let error = error {
            print("Error saving recording: \(error)")
        }
        print("Url: \(outputFileURL.path)")
        updateViews()
         playVideo(url:outputFileURL)
        
    }
}
