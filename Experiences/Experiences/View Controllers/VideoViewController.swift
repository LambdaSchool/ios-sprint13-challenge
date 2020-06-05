//
//  VideoViewController.swift
//  Experiences
//
//  Created by Brandi Bailey on 1/17/20.
//  Copyright © 2020 Brandi Bailey. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData
import MapKit

class VideoViewController: UIViewController {
    
    var experienceLocation: CLLocation?
    
    lazy private var captureSession = AVCaptureSession()
    lazy private var fileOutput = AVCaptureMovieFileOutput()
    var player: AVPlayer?
    
    var date = Date()
    
    var df: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.autoupdatingCurrent
        formatter.dateFormat = "h:mm:ss | LLL dd, yyyy"
        return formatter
    }
    
    let experienceURL = { () -> URL in
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        
        let name = formatter.string(from: Date())
        let fileURL = documentsDirectory.appendingPathComponent(name).appendingPathExtension("mov")
        
        return fileURL
    }
    
    @IBOutlet weak var cameraView: CameraPreviewView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var videoTitleTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Resize camera preview to fill the entire screen
        cameraView.videoPlayerView.videoGravity = .resizeAspectFill
        setupCamera()
        
        // Add tap gesture to replay video (repeat loop)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(tapGesture:)))
        view.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func handleTapGesture(tapGesture: UITapGestureRecognizer) {
        print("play movie")
        if tapGesture.state == .ended {
            playRecording()
        }
    }
    
    @IBAction func recordTapped(_ sender: Any) {
        toggleRecording()
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        
        let experience = Experience(context: CoreDataStack.context)
        
        guard let experienceLocation = experienceLocation else { return }
        
        let latitude = Double(experienceLocation.coordinate.latitude)
        let longitude = Double(experienceLocation.coordinate.longitude)
            
        
        experience.title = videoTitleTextField.text
        experience.latitude = latitude
        experience.longitude = longitude
        experience.mediaURL = experienceURL()
        experience.mediaType = ".mov"
        experience.date = Date.currentTimeStamp

        CoreDataStack.saveContext()
        
        self.navigationController?.popToRootViewController(animated: true)
       
    }
    
    
    
    func playRecording() {
        if let player = player {
            player.seek(to: CMTime.zero)
            player.play()
        }
    }
    
    func updateViews() {
        recordButton.isSelected = fileOutput.isRecording
    }
    
    func toggleRecording() {
        if fileOutput.isRecording {
            //stop
            fileOutput.stopRecording()
        } else {
            //start
            fileOutput.startRecording(to: newRecordingURL(), recordingDelegate: self)
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
    
    func setupCamera() {
        let camera = bestCamera()
        
        //make changes inside the devices connected
        guard let cameraInput = try? AVCaptureDeviceInput(device: camera) else {
            fatalError("Cannot create camera input")
        }
        
        guard captureSession.canAddInput(cameraInput) else {
            fatalError("Cannot add camera input to session")
        }
        
        captureSession.addInput(cameraInput)
        
        if captureSession.canSetSessionPreset(.hd1920x1080) {
            //            captureSession.setSessionPreset(.hd1920x1080)
            captureSession.sessionPreset = .hd1920x1080
        }
        
        guard captureSession.canAddOutput(fileOutput) else {
            fatalError("Can't setup the file output for the movie")
        }
        
        captureSession.addOutput(fileOutput)
        
        let microphone = bestAudio()
        guard let audioInput = try? AVCaptureDeviceInput(device: microphone) else {
            fatalError("Can't create input from microphone")
        }
        guard captureSession.canAddInput(audioInput) else {
            fatalError("Can't add audio input")
        }
        captureSession.addInput(audioInput)
        
        //Video output (movie)
        
        captureSession.commitConfiguration()
        cameraView.session = captureSession
    }
    
    private func bestAudio() -> AVCaptureDevice {
        if let device = AVCaptureDevice.default(for: .audio) {
            return device
        }
        fatalError("No audio")
    }
    
    private func bestCamera() -> AVCaptureDevice {
        if let device = AVCaptureDevice.default(.builtInUltraWideCamera, for: .video, position: .back) {
            return device
        }
        // Fall back camera
        
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            return device
        }
        
        fatalError("No cameras on this device.  Or are you running on the simulator?  (not supported)")
    }
    
    /// Creates a new file URL in the documents directory
    private func newRecordingURL() -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        
        let name = formatter.string(from: Date())
        let fileURL = documentsDirectory.appendingPathComponent(name).appendingPathExtension("mov")
        
        return fileURL
    }
    
    func playMovie(url: URL) {
        player = AVPlayer(url: url)
        let playerLayer = AVPlayerLayer(player: player)
        var topRect = view.bounds
        topRect.size.height = topRect.height / 4
        topRect.size.width = topRect.width / 4
        topRect.origin.y = view.layoutMargins.top
        playerLayer.frame = topRect
        view.layer.addSublayer(playerLayer)
        player?.play()
        
    }
    
}

extension VideoViewController: AVCaptureFileOutputRecordingDelegate {
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        
        if let error = error {
            print(error)
        }
        print("Video: \(outputFileURL.path)")
        updateViews()
        
        playMovie(url: outputFileURL)
    }
}

extension Date {
    static var currentTimeStamp: Date {
        return Date()
    }
}

extension VideoViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        videoTitleTextField.resignFirstResponder()
        
        return true
    }
}


