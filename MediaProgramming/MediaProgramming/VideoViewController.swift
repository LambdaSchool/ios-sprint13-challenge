//
//  VideoViewController.swift
//  MediaProgramming
//
//  Created by Yvette Zhukovsky on 1/18/19.
//  Copyright © 2019 Yvette Zhukovsky. All rights reserved.
//
import AVFoundation
import Photos
import UIKit
import CoreImage

class VideoViewController: UIViewController, AVCaptureFileOutputRecordingDelegate,UINavigationControllerDelegate, CLLocationManagerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
     setupRecording()
      
    }
    
    @IBAction func saveVideo(_ sender: Any) {
        guard let experienceTitle = experienceTitle,
            let audioURL = audioURL,
            let videoURL = videoURL,
            let image = image,
            let coordinate = coordinate else { return }
        experiencesController?.makingExperiences(coordinate: coordinate, title: experienceTitle, image: image, audioURL: audioURL, videoURL: videoURL)
        self.navigationController?.popToRootViewController(animated: true)
        
    }
 
    @IBAction func recordingVideo(_ sender: Any) {
        if recordOutput.isRecording {
            recordOutput.stopRecording()
        } else {
            recordOutput.startRecording(to: newRecordingURL(), recordingDelegate: self)
        }
    }
    
    
    
    
    @IBOutlet weak var recordButton: UIButton!
 
    @IBOutlet weak var videoView: CameraPreviewView!
    

    var experiencesController: ExperiencesController?
    private var captureSession: AVCaptureSession!
    private var recordOutput: AVCaptureMovieFileOutput!
   var image: UIImage?
    var experienceTitle: String?
    var audioURL: URL?
    var coordinate: CLLocationCoordinate2D?
    var videoURL: URL?
    private let imageFilter = CIFilter(name: "CIPhotoEffectFade")!
    private let context = CIContext(options: nil)
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        captureSession.startRunning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        captureSession.stopRunning()
    }
   
    
    
    
   
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        DispatchQueue.main.async {
            self.updateViews()
        }
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        DispatchQueue.main.async {
            self.updateViews()
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status != .authorized {
                    NSLog("Please give Experiences access to your photos in settings.")
                    return
                }
                
                PHPhotoLibrary.shared().performChanges({
                    self.videoURL = outputFileURL
                    PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputFileURL)
                }, completionHandler: { (success, error) in
                    if let error = error {
                        NSLog("Error saving video to photo library: \(error)")
                    }
                })
            })
        }
    }
    
   
    private func setupRecording() {
        let captureSession = AVCaptureSession()
        let device = bestCamera()
        
      
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: device),
            captureSession.canAddInput(videoDeviceInput) else {
                fatalError()
        }
        captureSession.addInput(videoDeviceInput)
        
        let fileOutput = AVCaptureMovieFileOutput()
        guard captureSession.canAddOutput(fileOutput) else { fatalError() }
        captureSession.addOutput(fileOutput)
        recordOutput = fileOutput
        
        captureSession.sessionPreset = .hd1920x1080
        captureSession.commitConfiguration()
        
        self.captureSession = captureSession
         videoView.videoPreviewLayer.session = captureSession
    }
    
    private func bestCamera() -> AVCaptureDevice {
        if let device = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) {
            return device
        } else if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            return device
        } else {
            fatalError("Missing expected back camera device")
        }
    }
    
    private func newRecordingURL() -> URL {
        let fm = FileManager.default
        let documentsDir = try! fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        return documentsDir.appendingPathComponent(UUID().uuidString).appendingPathExtension("mov")
    }
    
    private func updateViews() {
        guard isViewLoaded else { return }
        let recordButtonImageName = recordOutput.isRecording ? "Stop" : "Record"
        recordButton.setImage(UIImage(named: recordButtonImageName)!, for: .normal)
    }
   
}
