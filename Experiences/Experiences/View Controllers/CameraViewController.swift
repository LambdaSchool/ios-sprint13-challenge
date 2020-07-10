//
//  CameraViewController.swift
//  Experiences
//
//  Created by Enayatullah Naseri on 3/21/20.
//  Copyright © 2020 Enayatullah Naseri. All rights reserved.
//

import UIKit
import AVFoundation
import MapKit

class CameraViewController: UIViewController {

    // MARK: - Properties
    
    lazy private var captureSession = AVCaptureSession()
    lazy private var fileOutput = AVCaptureMovieFileOutput()
    
    let locationManager = CLLocationManager()
    
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer?
    
    var experienceController: ExperienceController?
    var experienceTitle: String?
    var imageData: Data?
    var audioURL: URL?
    var videoURL: URL?
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    
    // MARK: - Outlets
    @IBOutlet weak var cameraView: CameraPreviewView!
    @IBOutlet weak var recordButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpCamera()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGuesture(_:)))
        view.addGestureRecognizer(tapGesture)
        
        // user autorization
        self.locationManager.requestAlwaysAuthorization()
        
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
    }
    
    // MARK: - helpGesture
    @objc func handleTapGuesture(_ tapGesture: UITapGestureRecognizer) {
        print("tap")
        switch tapGesture.state {
        case .ended:
            playRecording()
        default:
            print("Handle other states: \(tapGesture.state)")
        }
    }
    
    func playRecording() {
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
    
    // MARK: - Camera setup
    private func setUpCamera() {
        let camera = bestCamera()
        
        captureSession.beginConfiguration()
        guard let cameraInput = try? AVCaptureDeviceInput(device: camera) else {
            fatalError("Can't create an input")
        }
        
        guard captureSession.canAddInput(cameraInput) else {
            fatalError("This session cannot handle this type of input: \(cameraInput)")
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
        
        cameraView.session = captureSession
    }
    
    // MARK: - Best camera
    private func bestCamera() -> AVCaptureDevice {
        if let device = AVCaptureDevice.default(.builtInUltraWideCamera, for: .video, position: .back) {
            return device
        }
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            return device
        }
        
        fatalError("No cameras on the device (or you are running it on the iPhone simulator)")
    }
    
    private func bestAudio() -> AVCaptureDevice {
        if let device = AVCaptureDevice.default(for: .audio) {
            return device
        }
        fatalError("No audio")
    }
    
    
    func newRecordingURL() -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        let name = formatter.string(from: Date())
        let fileURL = documentsDirectory.appendingPathComponent(name).appendingPathExtension("mov")
        return fileURL
    }
    
    private func updateViews() {
        recordButton.isSelected = fileOutput.isRecording
    }
    
    func playMovie(url: URL) {
        player = AVPlayer(url: url)
        
        playerLayer = AVPlayerLayer(player: player)
        var topRect = view.bounds
        topRect.size.height = topRect.height / 1.5
        topRect.size.width = topRect.width / 1.5
        topRect.origin.y = view.safeAreaInsets.top
        playerLayer?.frame = topRect
        view.layer.addSublayer(playerLayer!)
        
        player.play()
    }
    
    private func toggleRecord() {
        if fileOutput.isRecording {
            fileOutput.stopRecording()
        } else {
            playerLayer?.removeFromSuperlayer()
            fileOutput.startRecording(to: newRecordingURL(), recordingDelegate: self)
        }
    }

    
// MARK: - aution buttons
    @IBAction func recordButtonTapped(_ sender: Any) {
        toggleRecord()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let experienceController = experienceController,
                    let experienceTitle = experienceTitle,
                    let imageData = imageData,
                    let audioURL = audioURL,
                    let videoURL = videoURL,
                    let latitude = latitude,
                    let longitude = longitude else {
                        print("Unable to save.")
                        return
                }
        
        
        let newExperience = Experience(experienceTitle: experienceTitle, imageData: imageData, audioURL: audioURL, videoURL: videoURL, latitude: latitude, longitude: longitude)
        experienceController.experiences.append(newExperience)
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    



}

// MARK: - extention

extension CameraViewController: AVCaptureFileOutputRecordingDelegate, CLLocationManagerDelegate{
    
    // MARK: - Delegate
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let error = error {
            print("Error saving video: \(error)")
        }
        videoURL = outputFileURL
        updateViews()
        
        playMovie(url: outputFileURL)
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        updateViews()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        latitude = locValue.latitude
        longitude = locValue.longitude
    }
    
}
