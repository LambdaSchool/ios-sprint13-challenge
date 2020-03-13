//
//  VideoViewController.swift
//  ExperiencesSprint
//
//  Created by Jorge Alvarez on 3/13/20.
//  Copyright © 2020 Jorge Alvarez. All rights reserved.
//

import UIKit
import AVFoundation

class VideoViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var cameraView: CameraPreviewView!
    @IBOutlet weak var recordVideoButton: UIButton!
    
    // Add capture session
    lazy private var captureSession = AVCaptureSession()
    
    // Add movie output
    lazy private var fileOutput = AVCaptureMovieFileOutput() // allows you to save a .mov file

    var player: AVPlayer!
    var storedURL: URL?
    var experienceController: ExperienceController?
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        print("savedButtonTapped")
        
        guard experienceController?.videoURL != nil else { return }
//        guard let experienceController = experienceController else { return }
//        let newExp = Experience(comment: experienceController.comment, coordinate: experienceController.coordinate, image: experienceController.image, audioURL: experienceController.audioURL, videoURL: experienceController.videoURL)
//
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func recordVideoTapped(_ sender: UIButton) {
        print("recordVideoTapped")
        toggleRecording()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Resize camera preview to fill the entire screen
        cameraView.videoPlayerView.videoGravity = .resizeAspectFill
        setupCaptureSession()
        // Do any additional setup after loading the view.
    }
    
    /// Checks to see if you're recording or not
    private func toggleRecording() {

        if fileOutput.isRecording {
            // Stop
            fileOutput.stopRecording()
            print("stopped recording, storedURL = \(storedURL)")
            //present(alertController, animated: true)
        } else {
            // Start
            // FIXME: Store URL
            storedURL = newRecordingURL()
            print("started recording: \(storedURL)")
            fileOutput.startRecording(to: storedURL!, recordingDelegate: self)
        }
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
    
    private func setupCaptureSession() {
        let camera = bestCamera()
        
        // Open
        captureSession.beginConfiguration()
        
        // Add inputs
        guard let cameraInput = try? AVCaptureDeviceInput(device: camera), captureSession.canAddInput(cameraInput) else {
            fatalError("can't create camera with current input")
        }
        captureSession.addInput(cameraInput)
        
        // switch to 1080p or 4k video
        if captureSession.canSetSessionPreset(.hd1920x1080) {
            captureSession.sessionPreset = .hd1920x1080 // 1080p
        }
        
        // Add microphone
        let microphone = bestAudio()
        guard let audioInput = try? AVCaptureDeviceInput(device: microphone),
            captureSession.canAddInput(audioInput) else {
                fatalError("Can't create and add input from microphone")
        }
        captureSession.addInput(audioInput)
        
        
        // Add outputs
        guard captureSession.canAddOutput(fileOutput) else {
            fatalError("cannot save movie to capture session")
        }
        captureSession.addOutput(fileOutput)
        
        // Close
        captureSession.commitConfiguration()
        cameraView.session = captureSession
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
        recordVideoButton.isSelected = fileOutput.isRecording
    }
    
    private func bestAudio() -> AVCaptureDevice {
        if let device = AVCaptureDevice.default(for: .audio) {
            return device
        }
        fatalError("No audio")
    }

    private func bestCamera() -> AVCaptureDevice {
        // ultra wide lens (0.5)
        if let device = AVCaptureDevice.default(.builtInUltraWideCamera, for: .video, position: .back) {
            return device
        }
        // wide angle lens (available on every single iPhone)
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            return device
        }
        
        // if none of these exist, we'll fatalError() (on simulator)
        fatalError("no cameras on device, or you're on the simualor")
        // Potentially the hardware is missing or broken (if the user serviced the device, or dropped in pool)
    }
}

extension VideoViewController: AVCaptureFileOutputRecordingDelegate {
    // Apple done goofed
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        
        updateViews()
        
        if let error = error {
            print("Error recording video to :\(outputFileURL) : \(error)")
            return
        }
        
        //playMovie(url: outputFileURL)
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        updateViews()
    }
}

class CameraViewController: UIViewController {
    
    // MARK: - Properties
    
    var storedURL: URL?

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var cameraView: CameraPreviewView!
    
    fileprivate lazy var alertController: UIAlertController = {
        let ac = UIAlertController(title: "Add Video Post Title", message: "Enter a title for this video post", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            guard let postTitle = self.tf?.text else { return }
            print(postTitle)
            //print(self.tf?.text ?? "")
            // 3
//            self.videoPostDelegate.didCreatePost(post: Post(comment: postTitle, timestamp: Date(), url: self.storedURL!))
            //self.saveCalorieIntake()
            self.tf?.text = ""
            self.dismiss(animated: true, completion: nil)
            // ring bell
            //NotificationCenter.default.post(name: .updateViews, object: self)
        }))
        
        ac.addTextField { textField in
            self.tf = textField
        }
        return ac
    }()
    
    fileprivate var tf: UITextField?
    
    // Add capture session
    lazy private var captureSession = AVCaptureSession()
    
    // Add movie output
    lazy private var fileOutput = AVCaptureMovieFileOutput() // allows you to save a .mov file

    var player: AVPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Resize camera preview to fill the entire screen
        cameraView.videoPlayerView.videoGravity = .resizeAspectFill
        setupCaptureSession()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupCaptureSession() {
        let camera = bestCamera()
        
        // Open
        captureSession.beginConfiguration()
        
        // Add inputs
        guard let cameraInput = try? AVCaptureDeviceInput(device: camera), captureSession.canAddInput(cameraInput) else {
            fatalError("can't create camera with current input")
        }
        captureSession.addInput(cameraInput)
        
        // switch to 1080p or 4k video
        if captureSession.canSetSessionPreset(.hd1920x1080) {
            captureSession.sessionPreset = .hd1920x1080 // 1080p
        }
        
        // Add microphone
        let microphone = bestAudio()
        guard let audioInput = try? AVCaptureDeviceInput(device: microphone),
            captureSession.canAddInput(audioInput) else {
                fatalError("Can't create and add input from microphone")
        }
        captureSession.addInput(audioInput)
        
        
        // Add outputs
        guard captureSession.canAddOutput(fileOutput) else {
            fatalError("cannot save movie to capture session")
        }
        captureSession.addOutput(fileOutput)
        
        // Close
        captureSession.commitConfiguration()
        cameraView.session = captureSession
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        captureSession.startRunning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        captureSession.stopRunning()
    }
    
    private func bestAudio() -> AVCaptureDevice {
        if let device = AVCaptureDevice.default(for: .audio) {
            return device
        }
        fatalError("No audio")
    }

    private func bestCamera() -> AVCaptureDevice {
        // ultra wide lens (0.5)
        if let device = AVCaptureDevice.default(.builtInUltraWideCamera, for: .video, position: .back) {
            return device
        }
        // wide angle lens (available on every single iPhone)
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            return device
        }
        
        // if none of these exist, we'll fatalError() (on simulator)
        fatalError("no cameras on device, or you're on the simualor")
        // Potentially the hardware is missing or broken (if the user serviced the device, or dropped in pool)
    }
    
    @IBAction func recordTapped(_ sender: UIButton) {
        print("recordTapped")
        toggleRecording()
    }
    
    /// Checks to see if you're recording or not
    private func toggleRecording() {

        if fileOutput.isRecording {
            // Stop
            fileOutput.stopRecording()
            print("stopped recording, storedURL = \(storedURL)")
            present(alertController, animated: true)
        } else {
            // Start
            // FIXME: Store URL
            storedURL = newRecordingURL()
            print("started recording: \(storedURL)")
            fileOutput.startRecording(to: storedURL!, recordingDelegate: self)
        }
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

    private func updateViews() {
        recordButton.isSelected = fileOutput.isRecording
    }
    
    func playMovie(url: URL) {
        player = AVPlayer(url: url)
        let playerLayer = AVPlayerLayer(player: player)
        var topRect = view.bounds
        topRect.size.height = topRect.height / 4
        topRect.size.width = topRect.width / 4
        topRect.origin.y = view.layoutMargins.top
        playerLayer.frame = topRect
        view.layer.addSublayer(playerLayer) // this is stacking layers (BAD)
        player.play()
    }
    
    @objc func handleTapGesture(_ tapGesture: UITapGestureRecognizer) {
        print("tap")
        switch(tapGesture.state) {
        case .ended:
            replayMovie()
        default:
            print("Handled other states: \(tapGesture.state)")
        }
    }
    
    func replayMovie() {
        guard let player = player else { return }
        
        // Go back to beginning
        player.seek(to: CMTime.zero)
        //CMTime(seconds: 2, preferredTimescale: 30) // 30 Frames per second (FPS)
        player.play()
    }
}

extension CameraViewController: AVCaptureFileOutputRecordingDelegate {
    // Apple done goofed
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        
        updateViews()
        
        if let error = error {
            print("Error recording video to :\(outputFileURL) : \(error)")
            return
        }
        
        //playMovie(url: outputFileURL)
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        updateViews()
    }
}

