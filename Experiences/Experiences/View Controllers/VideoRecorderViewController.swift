//
//  VideoRecorderViewController.swift
//  Experiences
//
//  Created by Waseem Idelbi on 9/11/20.
//

import UIKit
import AVFoundation

class VideoRecorderViewController: UIViewController {
    
    //MARK: - Properties -
    lazy private var captureSession = AVCaptureSession()
    lazy private var fileOutput = AVCaptureMovieFileOutput()
    var player: AVPlayer!
    var isRecroding: Bool {
        return fileOutput.isRecording
    }
    
    //MARK: - IBOutlets -
    @IBOutlet weak var cameraView: CameraPreviewView!
    @IBOutlet weak var recordButton: UIButton!
    
    //MARK: - IBActions -
    @IBAction func recordButtonTapped(_ sender: UIButton) {
        toggleRecord()
    }
    
    //MARK: - Life Cycle Methods -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestPermissionAndShowCamera()
        setUpCaptureSession()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        captureSession.startRunning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        captureSession.stopRunning()
    }
    
    //MARK: - Camera Configuration -
    
    private func setUpCaptureSession() {
        let camera = bestCamera()
        let microphone = bestAudio()
        
        ///Beginning of Session Configuration
        captureSession.beginConfiguration()
        
        guard let cameraInput = try? AVCaptureDeviceInput(device: camera),
            captureSession.canAddInput(cameraInput) else {
                fatalError("Can't create an input from the camera, do something better than crashing")
        }
        
        if captureSession.canSetSessionPreset(.hd1920x1080) {
            captureSession.sessionPreset = .hd1920x1080
        }
        
        guard let audioInput = try? AVCaptureDeviceInput(device: microphone),
            captureSession.canAddInput(audioInput) else {
                fatalError("Can't create and add input from microphone")
        }
        
        guard captureSession.canAddOutput(fileOutput) else {
            fatalError("Can't record movie to disk")
        }
        
        captureSession.addInput(cameraInput)
        captureSession.addInput(audioInput)
        captureSession.addOutput(fileOutput)
        
        captureSession.commitConfiguration()
        ///End of Session Configuration
        
        cameraView.session = captureSession
    }
    
    private func bestCamera() -> AVCaptureDevice {
        
        if let camera = AVCaptureDevice.default(.builtInUltraWideCamera, for: .video, position: .back) {
            return camera
        }
        
        if let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            return camera
        }
        
        fatalError("No cameras on the device (or you are running it on the iPhone simulator")
    }
    
    private func bestAudio() -> AVCaptureDevice {
        if let mic = AVCaptureDevice.default(for: .audio) {
            return mic
        }
        fatalError("No Audio")
    }
    
    private func showCamera() {
        
    }
    
    private func requestPermissionAndShowCamera() {
        
        AVCaptureDevice.requestAccess(for: .audio) { (authorized) in
            if !authorized {
                print("The user did not authorize the use of the mic")
                print("tell the user to change the mic settings")
            }
        }
        
        let videoStatus = AVCaptureDevice.authorizationStatus(for: .video)
        let audioStatus = AVCaptureDevice.authorizationStatus(for: .audio)
        
        //Audio Permission
        switch audioStatus {
            
        case .notDetermined:
            print("audio permission status has not been determined")
            
        case .restricted:
            print("Parental controls do not allow the use of the user's microphone")
            
        case .denied:
            print("Tell the user that the video will be muted")
            print("The user has denied acccess to their microphone, ask the user the change this in settings")
            
        case .authorized:
            print("permission to use microphone has been authorized")
            
        @unknown default:
            print("ERROR: Please review requestPermissionAndShowCamera() in the ViewController file")
        }
        
        //Video Permission
        switch videoStatus {
            
        case .notDetermined:
            requestPermission()
            
        case .restricted:
            fatalError("Video is disabled for parental controls")
            
        case .denied:
            fatalError("Tell user they need to enable Privacy for Video/Camera/Microphone")
            
        case .authorized:
            showCamera()
            
        default:
            fatalError("A new status was added that we need to handle")
        }
    }
    
    private func requestPermission() {
        AVCaptureDevice.requestAccess(for: .video) { (granted) in
            guard granted else {
                fatalError("Tell user they need to enable Privacy for Video/Camera/Microphone")
            }
            DispatchQueue.main.async { [weak self] in
                //                self?.showCamera()
            }
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
    
    private func toggleRecord() {
        if isRecroding {
            fileOutput.stopRecording()
            recordButton.setTitle("Record", for: .normal)
        }
        else {
            fileOutput.startRecording(to: newRecordingURL(), recordingDelegate: self)
            recordButton.setTitle("Stop", for: .normal)
        }
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

        player.play()
    }
    
    func replayMovie() {
        guard let player =  player else { return }
        player.seek(to: .zero)
        player.play()
    }
    
    func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
    }
    
    @objc func handleTapGesture(_ tapGesture: UITapGestureRecognizer) {
        print("tap")
        
        switch tapGesture.state {
        case .ended:
            replayMovie()
        default:
            print("Handled other states: \(tapGesture.state)")
        }
    }
    
}

extension VideoRecorderViewController: AVCaptureFileOutputRecordingDelegate {
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        recordButton.setTitle("Stop", for: .normal)
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        
        if let error = error {
            print("Error saving video: \(error)")
        }
        
        print("Video: \(outputFileURL.path)")
        recordButton.setTitle("Record", for: .normal)
    
        playMovie(url: outputFileURL)
    }
    
    
}
