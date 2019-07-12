//
//  VideoRecordingViewController.swift
//  Experiences
//
//  Created by Mitchell Budge on 7/12/19.
//  Copyright © 2019 Mitchell Budge. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation

class VideoRecordingViewController: UIViewController {

    // MARK: - Properties
    
    lazy private var captureSession = AVCaptureSession()
    lazy private var fileOutput = AVCaptureMovieFileOutput()
    private var player: AVPlayer!
    var experienceController: ExperienceController?
    var coordinate: CLLocationCoordinate2D?
    var name: String?
    var image: UIImage?
    var audio: URL?
    var video: URL?
    
    @IBOutlet weak var cameraPreviewView: CameraPreviewView!
    @IBOutlet weak var recordStopButton: UIButton!
    
    // MARK: - Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let camera = bestCamera()
        guard let cameraInput = try? AVCaptureDeviceInput(device: camera) else {
            fatalError()
        }
        if captureSession.canAddInput(cameraInput) {
            captureSession.addInput(cameraInput)
        }
        
        if captureSession.canAddOutput(fileOutput) {
            captureSession.addOutput(fileOutput)
        }
        
        if captureSession.canSetSessionPreset(.hd1920x1080) {
            captureSession.canSetSessionPreset(.hd1920x1080)
        }
        
        captureSession.commitConfiguration()
        
        cameraPreviewView.session = captureSession
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        
        view.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func handleTapGesture(_ tapGesture: UITapGestureRecognizer) {
        print("Play movie")
        if let player = player {
            player.seek(to: CMTime.zero)
            player.play()
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
    
    private func bestCamera() -> AVCaptureDevice {
        if let device = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) {
            return device
        }
        
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            return device
        }
        
        fatalError("No cameras exist - you're probably running on the simulator")
    }
    
    func newRecordingURL() -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let name = "movie"
        let url = documentsDirectory.appendingPathComponent(name).appendingPathExtension("mov")
        print("URL: \(url)")
        return url
    }
    
    func updateViews() {
        if fileOutput.isRecording {
            recordStopButton.setImage(UIImage(named: "Stop"), for: .normal)
            recordStopButton.tintColor = UIColor.black
        } else {
            recordStopButton.setImage(UIImage(named: "Record"), for: .normal)
            recordStopButton.tintColor = UIColor.red
        }
    }
    
    func playMovie(url: URL) {
        player = AVPlayer(url: url)
        let playerLayer = AVPlayerLayer(player: player)
        var topRect = self.view.bounds
        topRect.size.width = topRect.width / 4
        topRect.size.height = topRect.height / 4
        playerLayer.frame = topRect
        view.layer.addSublayer(playerLayer)
        player.play()
    }
    
    @IBAction func recordStopButtonPressed(_ sender: Any) {
        if fileOutput.isRecording {
            fileOutput.stopRecording()
        } else {
            fileOutput.startRecording(to: newRecordingURL(), recordingDelegate: self)
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        guard let experienceController = experienceController,
            let coordinate = coordinate,
            let name = name,
            let image = image,
            let audio = audio,
            let video = video else { return }
        experienceController.createExperience(coordinate: coordinate, name: name, image: image, audio: audio, video: video)
        navigationController?.popToRootViewController(animated: true)
    }
    
    
}

extension VideoRecordingViewController: AVCaptureFileOutputRecordingDelegate {
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        DispatchQueue.main.async {
            self.updateViews()
        }
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        DispatchQueue.main.async {
            self.updateViews()
            self.playMovie(url: outputFileURL)
            self.video = outputFileURL
        }
    }
}
