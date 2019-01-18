//
//  VideoVC.swift
//  Experience
//
//  Created by Nikita Thomas on 1/18/19.
//  Copyright © 2019 Nikita Thomas. All rights reserved.
//

import UIKit
import AVKit

class VideoVC: UIViewController, AVCaptureFileOutputRecordingDelegate {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var previewView: CameraPreviewView!
    
    var experienceCont: ExperienceController!
    var experience: Experience?
    
    var imageURL: URL?
    var audioURL: URL?
    var experienceTitle: String?
    
    var videoURL: URL?
    
    var recordOutput: AVCaptureMovieFileOutput!
    var captureSession: AVCaptureSession!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupVideoCapture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        captureSession.startRunning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        captureSession.stopRunning()
    }
    
    
    @IBAction func donButtonTapped(_ sender: Any) {
        
        // TODO: Make stuff optional
        guard let imageURL = imageURL, let audioURL = audioURL, let experienceTitle = experienceTitle, let videoURL = videoURL, let location = LocationHelper.shared.currentLocation else { return }
        
        
        
        experienceCont.newExperience(title: experienceTitle, imageURL: imageURL, audioURL: audioURL, videoURL: videoURL, locationCoordinate: location.coordinate)
        
        navigationController?.popToRootViewController(animated: true)
        
    }
    
    @IBAction func recordButtonTapped(_ sender: Any) {
        
        if recordOutput.isRecording {
            recordOutput.stopRecording()
        } else {
            recordOutput.startRecording(to: newRecordingURL(), recordingDelegate: self)
        }
        
    }
    
    
    func updateViews() {
        let recordButtonTitle = recordOutput.isRecording ? "Stop" : "Record"
        recordButton.setImage(UIImage(named: recordButtonTitle)!, for: .normal)
    }
    
    func setupVideoCapture() {
        
        let captureSession = AVCaptureSession()
        let camera = bestCamera()
        
        guard let cameraInput = try? AVCaptureDeviceInput(device: camera),
            captureSession.canAddInput(cameraInput) else {
                fatalError("Could not add camera to capture session")
        }
        
        captureSession.addInput(cameraInput)
        
        
        // Add Outputs
        
        let movieOutput = AVCaptureMovieFileOutput()
        recordOutput = movieOutput
        
        guard captureSession.canAddOutput(movieOutput) else { fatalError("Cannot add movie file output to capture sessions")}
        
        captureSession.addOutput(movieOutput)
        
        captureSession.sessionPreset = .hd1920x1080
        captureSession.commitConfiguration()
        
        self.captureSession = captureSession
        previewView.videoPreviewLayer.session = captureSession
    }
    
    
    func bestCamera() -> AVCaptureDevice {
        
        // iPhone X or plus
        if let device = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) {
            return device
            
        } else if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            return device
        } else {
            // This should only run on simulator or device without camera
            fatalError("Missing camera")
        }
    }
    
    func newRecordingURL() -> URL {
        
        let fileManager = FileManager.default
        let documentsDir = try! fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        // The UUID is the name of the file
        let newRecordingURL = documentsDir.appendingPathComponent(UUID().uuidString).appendingPathExtension("caf")
        
        return newRecordingURL
    }
    
    
    // MARK: AVCapture Delegate
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        DispatchQueue.main.async {
            self.updateViews()
        }
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        DispatchQueue.main.async {
            self.updateViews()
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
