//
//  VideoRecordingViewController.swift
//  Experiences
//
//  Created by Christian Lorenzo on 5/17/20.
//  Copyright © 2020 Christian Lorenzo. All rights reserved.
//

import UIKit
import AVFoundation
import MapKit

class VideoRecordingViewController: UIViewController {
    
    var userLocation: CLLocationCoordinate2D?
    var picture: Experience.Picture?
    var experienceTitle: String?
    var recordingURL: Experience.Audio?
    
    lazy  private var captureSession = AVCaptureSession()
    lazy private var fileOutput = AVCaptureMovieFileOutput()
    var videoURL: URL?
    var player: AVPlayer!
    var mapViewController: MapViewController?
    
    @IBOutlet weak var cameraView: CameraPreviewView!
    @IBOutlet weak var recordingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraView.videoPlayerLayer.videoGravity = .resizeAspectFill   //.resizeAspectFill
        setUpCamera()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    //MARK: - Methods:
    
    func updateViews() {
        recordingButton.isSelected = fileOutput.isRecording
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        captureSession.startRunning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        captureSession.stopRunning()
    }
    
    //MARK: - Actions:
    
    @IBAction func startStopRecording(_ sender: Any) {
        toggleRecording()
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        guard let userLocation = userLocation else { return }
        guard let videoURL = videoURL else { return }
        guard let experienceTitle = experienceTitle else { return }
        guard let picture = picture else { return }
        guard let audio = recordingURL else { return }
        guard let mapViewController = mapViewController else { return }
        
        let video = Experience.Video(videoPost: videoURL)
        mapViewController.experience = Experience(experienceTitle: experienceTitle,
                                                  geotag: userLocation,
                                                  picture: picture,
                                                  video: video,
                                                  audio: audio)
        
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func handleTapGesture(_ tapGesture: UITapGestureRecognizer) {
        switch tapGesture.state {
        case .ended:
            playRecording()
        default:
            print("Handled other tap states: \(tapGesture.state)")
        }
    }
    
    func playMovie(url: URL) {
        
        player = AVPlayer(url: url)
        let playerLayer = AVPlayerLayer(player: player)
        
        var topRect = view.bounds
        topRect.origin.y = view.frame.origin.y
        
        playerLayer.frame = topRect
        
        playerLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(playerLayer)
        
        player.play()
    }
    
    func playRecording() {
        if let player = player {
            player.seek(to: CMTime.zero)
            player.play()
        }
    }
    
    func setUpCamera() {
        guard let camera = bestCamera() else { return }
        let microphone = bestMicrophone()
        
        captureSession.beginConfiguration()
        guard let cameraInput = try? AVCaptureDeviceInput(device: camera) else {
            let alert = UIAlertController(title: "No Camera", message: "Your camera may not be compatible", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
                return
            }))
            
            present(alert, animated: true)
            return
        }
        
        guard captureSession.canAddInput(cameraInput) else {
            preconditionFailure("Can't create an input \(cameraInput)")
        }
        
        captureSession.addInput(cameraInput)
        
        guard let microphoneInput = try? AVCaptureDeviceInput(device: microphone) else {
            preconditionFailure("Can't create an inout from microphone.")
        }
        
        captureSession.addInput(microphoneInput)
        
        if captureSession.canSetSessionPreset(.hd1920x1080) {
            captureSession.sessionPreset = .hd1920x1080
        }
        
        guard captureSession.canAddOutput(fileOutput) else {
            preconditionFailure("Cannot write to disk")
        }
        
        captureSession.addOutput(fileOutput)
        captureSession.commitConfiguration()
        cameraView.session = captureSession
    }
    
    private func toggleRecording() {
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
        videoURL = fileURL
        return fileURL
    }
    
    private func bestCamera() -> AVCaptureDevice? {
        if let device = AVCaptureDevice.default(.builtInUltraWideCamera, for: .video, position: .back) {
            return device
        }
        
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            return device
        } else {
            let alert = UIAlertController(title: "No Camera", message: "There is no suitable camera to use", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .destructive))
            
            present(alert, animated: true)
            recordingButton.isEnabled = false
            return nil
        }
    }
    
    private func bestMicrophone() -> AVCaptureDevice {
        if let device = AVCaptureDevice.default(for: .audio) {
            return device
        }
        
        preconditionFailure("No microhpne on the device is avilable")
    }
}


extension VideoRecordingViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let error = error {
            print("Error saving video: \(error)")
        }
        updateViews()
        playMovie(url: outputFileURL)
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        updateViews()
    }
}
