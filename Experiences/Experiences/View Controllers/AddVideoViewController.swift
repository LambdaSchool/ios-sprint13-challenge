//
//  AddVideoViewController.swift
//  Experiences
//
//  Created by Christopher Aronson on 7/12/19.
//  Copyright © 2019 Christopher Aronson. All rights reserved.
//

import UIKit
import CoreLocation
import AVFoundation

class AddVideoViewController: UIViewController {
    
    var currentLocation: CLLocation?
    var recordedURL: URL?
    var image: UIImage?
    var experienceName: String?
    var experienceController: ExperienceController?
    var previewLayer: AVCaptureVideoPreviewLayer!
    var videoURL: URL?

    lazy private var captureSession = AVCaptureSession()
    lazy private var fileOutput = AVCaptureMovieFileOutput()
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var cameraView: CameraPreviewView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        if AVCaptureDevice.authorizationStatus(for: .video) == .authorized {
            setupCaptureSession()
        } else {
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        self.setupCaptureSession()
                    }
                }
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        captureSession.startRunning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        captureSession.stopRunning()
    }
    
    private func setupCaptureSession() {
        
        let camera = bestCamera()
        
        guard let cameraInput = try? AVCaptureDeviceInput(device: camera) else { return }
        
        if captureSession.canAddInput(cameraInput) {
            captureSession.addInput(cameraInput)
        }
        
        guard let microphone = AVCaptureDevice.default(for: .audio),
            let microphoneInput = try? AVCaptureDeviceInput(device: microphone)
            else { return }
        
        if captureSession.canAddInput(microphoneInput) {
            captureSession.addInput(microphoneInput)
        }
        
        if captureSession.canAddOutput(fileOutput) {
            captureSession.addOutput(fileOutput)
        }
        
        if captureSession.canSetSessionPreset(.hd1920x1080) {
            captureSession.sessionPreset = .hd1920x1080
        }
        
        captureSession.commitConfiguration()
        
        cameraView.session = captureSession
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = cameraView.bounds
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraView.layer.addSublayer(previewLayer)
        
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

    private func newRecordingURL() -> URL {
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let name = UUID().uuidString  // TODO: Use ISO8601Formatter with a Date
        let url = documentsDirectory.appendingPathComponent(name).appendingPathExtension("mov")
        videoURL = url
        return url
    }
    
    func updateViews() {
        if fileOutput.isRecording {
            recordButton.setImage(#imageLiteral(resourceName: "Capture_Butt1"), for: .normal)
            recordButton.tintColor = UIColor.black
        } else {
            recordButton.setImage(#imageLiteral(resourceName: "Capture_Butt"), for: .normal)
            recordButton.tintColor = UIColor.red
        }
    }
    
    @IBAction func recordButtonPressed(_ sender: Any) {
        
        if fileOutput.isRecording {
            fileOutput.stopRecording()
        } else {
            fileOutput.startRecording(to: newRecordingURL(), recordingDelegate: self)
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let experienceController = experienceController,
        let currentLocation = currentLocation,
        let recordedURL = recordedURL,
        let image = image,
        let experienceName = experienceName,
        let videoURL = videoURL
        else { return }
        
        experienceController.createExperiences(experiencesName: experienceName,
                                               image: image,
                                               audioURL: recordedURL,
                                               videoURL: videoURL,
                                               location: currentLocation)
        
        navigationController?.popToRootViewController(animated: true)
        
    }
}

extension AddVideoViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        
        self.updateViews()
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        DispatchQueue.main.async {
            self.updateViews()
        }
    }

}
