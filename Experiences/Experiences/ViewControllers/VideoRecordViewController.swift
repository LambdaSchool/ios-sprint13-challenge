//
//  VideoRecordViewController.swift
//  Experiences
//
//  Created by Lambda_School_Loaner_34 on 3/29/19.
//  Copyright © 2019 Frulwinn. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class VideoRecordViewController: UIViewController {
    
    //MARK: - Properties
    var experienceController: ExperienceController?
    lazy private var captureSession = AVCaptureSession()
    lazy private var fileOutput = AVCaptureMovieFileOutput()
    
    
    //MARK: - Outlets
    @IBOutlet weak var cameraView: CameraPreviewView!
    @IBOutlet weak var recordButton: UIButton!
    @IBAction func recordButtonPressed(_ sender: Any) {
        
        if fileOutput.isRecording {
            fileOutput.stopRecording()
            
            //video file isn't finished saving yet ...
        } else {
            //start a recording
            fileOutput.startRecording(to: newRecordingURL(), recordingDelegate: self)
            
        }
    }
    
    //uses date formatter
    private func newRecordingURL() -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        
        let name = formatter.string(from: Date())
        let fileURL = documentsDirectory.appendingPathComponent(name).appendingPathExtension("mov")
        return fileURL
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //INPUTS
        //setup the capture session
        let camera = bestCamera()
        guard let cameraInput = try? AVCaptureDeviceInput(device: camera) else {
            fatalError("Can't create the input from the camera, do something else instead of crashing")
        }
        
        //add input to capture session
        guard captureSession.canAddInput(cameraInput) else {
            fatalError("This session can't handle this type of input")
        }
        captureSession.addInput(cameraInput)
        
        //set the camera resolution, configure camera
        if captureSession.canSetSessionPreset(.hd1920x1080) {
            captureSession.canSetSessionPreset(.hd1920x1080)
        }
        
        //commit set up
        captureSession.commitConfiguration()
        cameraView.session = captureSession
        
        //OUTPUTS
        //ask for confirmation to use
        guard captureSession.canAddOutput(fileOutput) else {
            fatalError("Cannot record to file")
        }
        //add output
        captureSession.addOutput(fileOutput)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        captureSession.startRunning()
        
        //request permission to use the camera
        let status = AVCaptureDevice.authorizationStatus(for: .video)

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        captureSession.stopRunning()
    }
    
    private func bestCamera() -> AVCaptureDevice {
        if let device = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) {
            return device
        }
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            return device
        }
        fatalError("No cameras on the device(orrunning in simulation)")
    }
    
    private func updateViews() {
        recordButton.isSelected = fileOutput.isRecording
    }
}

extension VideoRecordViewController: AVCaptureFileOutputRecordingDelegate {
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        
        PHPhotoLibrary.requestAuthorization { (status) in
            guard status == .authorized else {
                fatalError("handle situation where user declines photo library access: Settings > Privacy")
            }
            
            PHPhotoLibrary.shared().performChanges({
                //create a request to save video
                PHAssetCreationRequest.creationRequestForAssetFromVideo(atFileURL: outputFileURL)
                
            }, completionHandler: { (success, error) in
                if let error = error {
                    print("error saving video: \(error)")
                } else {
                    print("saving video succeeded: \(outputFileURL)")
                }
            })
        }
        
        DispatchQueue.main.async {
            self.updateViews()
        }
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        
        DispatchQueue.main.async {
            self.updateViews()
        }
    }
}
