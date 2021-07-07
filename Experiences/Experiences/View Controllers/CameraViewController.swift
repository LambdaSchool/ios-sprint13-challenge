//
//  CameraViewController.swift
//  Experiences
//
//  Created by Ilgar Ilyasov on 11/9/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class CameraViewController: UIViewController {
    
    @IBOutlet weak var cameraPreviewView: CameraPreviewView!
    @IBOutlet weak var recordButton: UIButton!
    
    var captureSession: AVCaptureSession!
    var recordingOutput: AVCaptureMovieFileOutput!
    
    var experienceController: ExperienceController?
    var imageData: Data?
    var experienceTitle: String?
    var audioURL: URL?
    var coordinate: CLLocationCoordinate2D?
    var videoURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let captureSession = AVCaptureSession()
        let cameraDevice = bestCamera()
        
        guard let microphone = AVCaptureDevice.default(.builtInMicrophone, for: .audio, position: .unspecified),
            let audioDeviceInput = try? AVCaptureDeviceInput(device: microphone),
            captureSession.canAddInput(audioDeviceInput) else { fatalError() }
        
        captureSession.addInput(audioDeviceInput)
        
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: cameraDevice),
            captureSession.canAddInput(videoDeviceInput) else { fatalError() }
        captureSession.addInput(videoDeviceInput)
        
        let fileOutput = AVCaptureMovieFileOutput()
        
        guard captureSession.canAddOutput(fileOutput) else { fatalError() }
        captureSession.addOutput(fileOutput)
        
        captureSession.sessionPreset = .hd1920x1080
        captureSession.commitConfiguration()
        
        recordingOutput = fileOutput
        self.captureSession = captureSession
        
        cameraPreviewView.videoPreviewLayer.session = captureSession
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        captureSession?.startRunning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        captureSession?.stopRunning()
    }
    
    @IBAction func recordTapped(_ sender: Any) {
        if recordingOutput.isRecording {
            recordingOutput.stopRecording()
        } else {
            recordingOutput.startRecording(to: newRecordingURL(), recordingDelegate: self)
        }
    }
    
    private func bestCamera() -> AVCaptureDevice {
        if let device = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) {
            return device
        } else if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            return device
        } else {
            fatalError("Missing back camera device")
        }
    }
    
    private func newRecordingURL() -> URL {
        let fm = FileManager.default
        let documentsDir = try! fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        return documentsDir.appendingPathComponent(UUID().uuidString).appendingPathExtension("mov")
    }
    
    func updateButton() {
        guard isViewLoaded else { return }
        
        let isRecording = recordingOutput.isRecording
        let recordButtonImageTitle = isRecording ? "Stop" : "Record"
        
        let image = UIImage(named: recordButtonImageTitle)
        recordButton.setImage(image, for: .normal)
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        guard let experienceTitle = experienceTitle,
            let audioURL = audioURL,
            let videoURL = videoURL,
            let imageData = imageData,
            let coordinate = coordinate else { return }
        experienceController?.createExperience(title: experienceTitle, imageData: imageData, audioURL: audioURL, videoURL: videoURL, coordinate: coordinate)
        
        let mapvView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ExperiencesViewController")
        present(mapvView, animated: true, completion: nil)
//        self.navigationController?.popToRootViewController(animated: true)
    }
}
