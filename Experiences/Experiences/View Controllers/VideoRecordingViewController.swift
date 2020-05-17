//
//  VideoRecordingViewController.swift
//  Experiences
//
//  Created by Alex Thompson on 5/17/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import AVFoundation
import MapKit

class VideoRecordingViewController: UIViewController {
    
    var userLocation: CLLocationCoordinate2D?
    var picture: Experience.Picture?
    var experienceTitle: String?
    var recordingURL: Experience.Audio?
    lazy private var captureSession = AVCaptureSession()
    lazy private var fileOutput = AVCaptureMovieFileOutput()
    var videoURL: URL?
    var player: AVPlayer!
    var mapViewController: MapViewController?
    
    @IBOutlet var recordingButton: UIButton!
    @IBOutlet var cameraView: CameraPreviewView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraView.videoPlayerLayer.videoGravity = .resizeAspectFill
        setupCamera()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        view.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        captureSession.startRunning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        captureSession.stopRunning()
    }
    
    @IBAction func startStopRecord(_ sender: UIButton) {
        toggleRecording()
    }
    
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        guard let userLocation = userLocation,
        let videoURL = videoURL,
        let experienceTitle = experienceTitle,
        let picture = picture,
        let audio = recordingURL,
        let mapViewController = mapViewController else { return }
        let video = Experience.Video(videoPost: videoURL)
        mapViewController.experience = Experience(experienceTitle: experienceTitle,
                                                  geotag: userLocation,
                                                  picture: picture,
                                                  video: video,
                                                  audio: audio)
    }
    
    
    @objc func handleTapGesture(_ tapGesture: UITapGestureRecognizer) {
        switch tapGesture.state {
        case .ended:
            playRecording()
        default:
            print("handled other tap states: \(tapGesture.state)")
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
    
    func setupCamera() {
        guard let camera = bestCamera() else { return }
        let microphone = bestMic()
        
        captureSession.beginConfiguration()
        guard let cameraInput = try? AVCaptureDeviceInput(device: camera) else {
            let alert = UIAlertController(title: "No usable camera", message: "Your camera may not be compatible with this app", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                return
            }))
            present(alert, animated: true)
            return
        }
        
        guard captureSession.canAddInput(cameraInput) else {
            preconditionFailure("This session cant handle this input: \(cameraInput)")
        }
        
        captureSession.addInput(cameraInput)
        
        guard let microphoneInput = try? AVCaptureDeviceInput(device: microphone) else {
            preconditionFailure("Cant create an input from microphone")
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
    
    private func updateViews() {
        recordingButton.isSelected = fileOutput.isRecording
    }
    
    private func bestCamera() -> AVCaptureDevice? {
        
        if let device = AVCaptureDevice.default(.builtInUltraWideCamera, for: .video, position: .back) {
            return device
        } else {
            let alert = UIAlertController(title: "No camera", message: "There is not a suitable camera to use", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .destructive))
            
            present(alert, animated: true)
            recordingButton.isEnabled = false
            return nil
        }
    }
    
    private func bestMic() -> AVCaptureDevice {
        if let device = AVCaptureDevice.default(for: .audio) {
            return device
        }
        
        preconditionFailure("No mic available to work")
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
