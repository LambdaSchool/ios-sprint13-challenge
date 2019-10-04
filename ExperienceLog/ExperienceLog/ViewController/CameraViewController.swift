//
//  CameraViewController.swift
//  ExperienceLog
//
//  Created by Bradley Yin on 10/4/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit
import AVFoundation



class CameraViewController: UIViewController {
    
    lazy private var captureSession = AVCaptureSession()
    lazy private var fileOutput = AVCaptureMovieFileOutput()
    private var player: AVPlayer!

    @IBOutlet var recordButton: UIButton!
    @IBOutlet var cameraView: CameraPreviewView!
    @IBOutlet weak var doneButton: UIBarButtonItem!

    
    var post: Post?
    var postController: PostController!
    var videoURL: URL?


    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
        updateViews()
        doneButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        captureSession.startRunning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        captureSession.stopRunning()
    }
    
    private func setupCamera() {
        // get camera
        let camera = bestCamera()
        guard let cameraInput = try? AVCaptureDeviceInput(device: camera) else {
            fatalError("cant create an input from this camera device")
        }
        guard captureSession.canAddInput(cameraInput) else {
            fatalError("this session cant handle this type of input")
        }
        captureSession.addInput(cameraInput)
        
        if captureSession.canSetSessionPreset(.hd1920x1080) {
            captureSession.sessionPreset = .hd1920x1080
        }
        
        let microphone = audio()
        guard let audioInput = try? AVCaptureDeviceInput(device: microphone) else {
            fatalError("cant create input from microphone")
        }
        guard captureSession.canAddInput(audioInput) else {
            fatalError("cant add audio input")
        }
        captureSession.addInput(audioInput)
        
        guard captureSession.canAddOutput(fileOutput) else {
            fatalError("cant record to file")
        }
        captureSession.addOutput(fileOutput)
        
        captureSession.commitConfiguration()
        
        cameraView.session = captureSession
        //set the capture session on the cameraView
    }
    
    private func bestCamera() -> AVCaptureDevice {
        if let device = AVCaptureDevice.default(.builtInUltraWideCamera, for: .video, position: .back) {
            return device
        } else {
            print("No ultra wide camera on the back")
        }
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            return device
        }
        
        fatalError("no camera detected")
    }
    private func audio() -> AVCaptureDevice {

        if let device = AVCaptureDevice.default(for: .audio) {
            return device
        }
        fatalError("No audio")
    }
    @IBAction func recordButtonPressed(_ sender: Any) {
        record()
    }
    @IBAction func donePressed(_ sender: UIBarButtonItem) {
        guard let post = post else { fatalError("no post pass to camera") }
        post.videoURL = self.videoURL
        postController.createNewPost(title: post.title, image: post.image, videoURL: post.videoURL, audioURL: post.audioURL, latitude: post.latitude, longitude: post.longitude, note: post.note)
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    private func playMovie(url: URL) {
        
        recordButton.isHidden = true
        cameraView.isHidden = true
        
        let tap = UIGestureRecognizer(target: self, action: #selector(replay))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tap)
        
        player = AVPlayer(url: url)
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = view.frame
        
        view.layer.addSublayer(playerLayer)
        
        player.play()
        
    }
    @objc private func replay() {
        player.seek(to: .zero)
        player.play()
    }
    
    func record() {
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
        return fileURL
    }
 
    
    func updateViews() {
        recordButton.isSelected = fileOutput.isRecording
        if recordButton.isSelected {
            recordButton.tintColor = .black
        } else {
            recordButton.tintColor = .red
        }
    }
}
extension CameraViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        DispatchQueue.main.async {
            self.updateViews()
            self.playMovie(url: outputFileURL)
            self.doneButton.isEnabled = true
            
        }
        
    }
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        DispatchQueue.main.async {
            self.updateViews()
        }
    }
    
}
