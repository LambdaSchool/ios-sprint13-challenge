//
//  VideoVC.swift
//  Experience
//
//  Created by Nikita Thomas on 1/18/19.
//  Copyright © 2019 Nikita Thomas. All rights reserved.
//

import UIKit
import AVKit

class VideoVC: UIViewController {

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
    
    
    
    @IBAction func donButtonTapped(_ sender: Any) {
        
        
    }
    
    @IBAction func recordButtonTapped(_ sender: Any) {
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
