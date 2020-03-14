//
//  VideoRecordingViewController.swift
//  Experiences
//
//  Created by Michael on 3/13/20.
//  Copyright © 2020 Michael. All rights reserved.
//

import UIKit
import AVFoundation
import MapKit

class VideoRecordingViewController: UIViewController {

    var experienceController: ExperienceController?
    
    var experience: Experience?
    
    lazy var captureSession = AVCaptureSession()
    
    lazy private var fileOutput = AVCaptureMovieFileOutput()
    
    var video: URL?
    
    var player: AVPlayer!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var cameraView: CameraPreviewView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        requestPermissionAndShowCamera()
        
        cameraView.videoPlayerView.videoGravity = .resizeAspectFill
        
        setupCaptureSession()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureRecognizer(_:)))
        
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        captureSession.startRunning()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        captureSession.stopRunning()
    }
    @IBAction func recordButtonTapped(_ sender: Any) {
        updateViews()
        toggleRecording()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        if let experience = experience {
                experience.video = video
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let newExperience = storyboard.instantiateViewController(identifier: "NewExperience") as! NewExperienceViewController
                }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func playButtonTapped(_ sender: Any) {
        replayMovie()
    }
    
    private func newRecordingURL() -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]

        let name = formatter.string(from: Date())
        let fileURL = documentsDirectory.appendingPathComponent(name).appendingPathExtension("mov")
        return fileURL
    }
    
    private func toggleRecording() {
        let url = newRecordingURL()
        if fileOutput.isRecording {
            fileOutput.stopRecording()
            print("Stopped recording")
        } else {
            print("Started recording: \(url)")
            fileOutput.startRecording(to: url, recordingDelegate: self)
        }
    }
    
    private func setupCaptureSession() {
        let camera = bestCamera()

        captureSession.beginConfiguration()

        guard
            let cameraInput = try? AVCaptureDeviceInput(device: camera),
            captureSession.canAddInput(cameraInput) else {
                fatalError("Can't create camera with current input")
        }
        captureSession.addInput(cameraInput)
        
        if captureSession.canSetSessionPreset(.hd1920x1080) {
            captureSession.sessionPreset = .hd1920x1080 // 1080p

        }
        
        let microphone = bestAudio()
        guard let audioInput = try? AVCaptureDeviceInput(device: microphone),
            captureSession.canAddInput(audioInput) else {
                fatalError("Can't create and add input from microphone")
        }
        captureSession.addInput(audioInput)
        
        guard captureSession.canAddOutput(fileOutput) else {
            fatalError("")
        }
        captureSession.addOutput(fileOutput)
        
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

        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            return device
        }
        
        fatalError("No Camera on device(or you're on the simulator and that isn't supported)")
    }
    
    private func updateViews() {
        recordButton.isSelected = fileOutput.isRecording
        if fileOutput.isRecording {
            recordButton.setImage(UIImage(systemName: "video.fill"), for: .normal)
            backButton.isHidden = true
            saveButton.isHidden = true
        } else {
            recordButton.setImage(UIImage(systemName: "video"), for: .normal)
            backButton.isHidden = false
            saveButton.isHidden = false
        }
        if video == nil {
            playButton.isHidden = true
        } else {
            playButton.isHidden = false
        }
    }
    
    func playMovie(url: URL) {
        player = AVPlayer(url: url)
        let playerLayer = AVPlayerLayer(player: player)
        var topRect = view.bounds
        topRect.size.height = topRect.height
        topRect.size.width = topRect.width
        topRect.origin.y = view.layoutMargins.top
        
        playerLayer.frame = topRect
        view.layer.addSublayer(playerLayer)
        
        player.play()
    }
    
    @objc func handleTapGestureRecognizer(_ tapGesture: UITapGestureRecognizer) {
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
        player.seek(to: CMTime.zero)
        //CMTime(seconds: 2, preferredTimescale: 30) // 30 Frames per second (FPS)
        player.play()
    }
    
    private func requestPermissionAndShowCamera() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .notDetermined:
            // First time user has seen the dialog, we don't have permission
            requestPermission()
        case .restricted:
            // parental controls restrict access to camera
            fatalError("Inform the user they cannot use the camera, they need parental permission ... show some kind of UI message")
        case .denied:
            // we asked for permission and they said no
            fatalError("Inform the user to enable camera/audio access in Settings > Privacy")
        case .authorized:
            // we asked for permission and they said yes
            self.cameraView.isHidden = false
        default:
            fatalError("Unexpected status for AVCaptureDevice authorization")
        }
    }
    
    private func requestPermission() {
        AVCaptureDevice.requestAccess(for: .video) { (granted) in
            guard granted else {
                fatalError("Inform the user to enable camera/audio access in Settings > Privacy")
            }
            DispatchQueue.main.async {
                self.cameraView.isHidden = false
            }
        }
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

extension VideoRecordingViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        updateViews()
        if let error = error {
            print("Error recording video to \(outputFileURL) \(error)")
            return
        }
        self.video = outputFileURL
        self.experience?.video = self.video
        playMovie(url: outputFileURL)
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        updateViews()
    }
}
