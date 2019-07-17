//
//  RecordVideoViewController.swift
//  Experiences
//
//  Created by Kobe McKee on 7/16/19.
//  Copyright © 2019 Kobe McKee. All rights reserved.
//

import UIKit
import CoreLocation
import AVFoundation

class RecordVideoViewController: UIViewController, AVCaptureFileOutputRecordingDelegate {
    

    var experienceController: ExperienceController?
    var coordinate: CLLocationCoordinate2D?
    var image: UIImage?
    var audioURL: URL?
    var videoURL: URL?
    var experienceTitle: String?
    var captureSession = AVCaptureSession()
    var recordOutput: AVCaptureMovieFileOutput!
    var player: AVPlayer!
    
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var cameraPreviewView: CameraPreviewView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCapture()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        captureSession.startRunning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        captureSession.stopRunning()
    }
    
    func updateViews() {
        if recordOutput.isRecording {
            recordButton.setImage(UIImage(named: "Stop"), for: .normal)
            recordButton.tintColor = .red
        } else {
            recordButton.setImage(UIImage(named: "Record"), for: .normal)
            recordButton.tintColor = .red
        }
    }
    

    
    func bestCamera() -> AVCaptureDevice {
        if let device = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) {
            return device
        }
        
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            return device
        }
        
        fatalError("No camera found")
    }
    
    private func setupCapture() {
        let captureSession = AVCaptureSession()
        let device = bestCamera()
        
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: device),
            captureSession.canAddInput(videoDeviceInput) else {
                fatalError()
        }
        
        captureSession.addInput(videoDeviceInput)
        
        let fileOutput = AVCaptureMovieFileOutput()
        
        guard captureSession.canAddOutput(fileOutput) else { fatalError() }
        
        captureSession.addOutput(fileOutput)
        
        captureSession.sessionPreset = .hd1920x1080
        captureSession.commitConfiguration()
        
        self.recordOutput = fileOutput
        self.captureSession = captureSession
        cameraPreviewView.videoPreviewLayer.session = captureSession
    }
    
    func newRecordingURL() -> URL {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let url = directory.appendingPathComponent(UUID().uuidString).appendingPathExtension("mov")
        return url
    }
    
    
    
    func playVideo(url: URL) {
        player = AVPlayer(url: url)
        let playerLayer = AVPlayerLayer(player: player)
        var rect = self.view.bounds
        rect.size.width = rect.width / 4
        rect.size.height = rect.height / 4
        playerLayer.frame = rect
        view.layer.addSublayer(playerLayer)
        player.play()
    }
    
    @IBAction func recordButtonPressed(_ sender: Any) {
        if recordOutput.isRecording {
            recordOutput.stopRecording()
        } else {
            recordOutput.startRecording(to: newRecordingURL(), recordingDelegate: self)
        }
    }
    
    
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        guard let experienceController = experienceController,
            let coordinate = coordinate else { return }
        experienceController.createExperience(coordinate: coordinate, title: title ?? nil, image: image ?? nil, audio: audioURL ?? nil, video: videoURL ?? nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        DispatchQueue.main.async {
            self.updateViews()
        }
    }
    
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        self.updateViews()
        self.playVideo(url: outputFileURL)
        self.videoURL = outputFileURL
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
