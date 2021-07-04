//
//  VideoViewController.swift
//  ChallengeExperience2
//
//  Created by Michael Flowers on 9/28/19.
//  Copyright © 2019 Michael Flowers. All rights reserved.
//

import UIKit
import AVFoundation
import MapKit

class VideoViewController: UIViewController {

    var coordinate: CLLocationCoordinate2D? {
        didSet {
            print("VideoViewController: coordinate  was set")
        }
    }
    
    var experienceController: ExperienceController? {
        didSet {
            print("VideoViewController: Expreience controller was set")
        }
    }
    
    var imageData: Data? {
        didSet{
            print("ImageDataWasSet")
        }
    }
    
    var audioURL: URL? {
        didSet {
            print("AudioURLWasSet")
        }
    }
    
    var experienceName: String? {
        didSet{
            print("experience name was set")
        }
    }
    
    let videoRecorder = VideoRecorder()
    
    @IBOutlet weak var recordProperties: UIButton!
    @IBOutlet weak var cameraView: CameraPreviewView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        videoRecorder.delegate = self
        videoRecorder.cameraCaptureSession(cameraPreviewView: cameraView)
        self.title = experienceName
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //start the session
        videoRecorder.startRunning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        videoRecorder.stopRunning()
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        //transition back to home viewController that will show annotation
        //this is where you CREATE AN EXPERIENCE -> APPEND TO THE ARRAY -> SO THAT THE TITLE CAN BE DISPLAYED ON THE MAP AS AN ANNOTATION.
      
        guard let experienceController = experienceController else { print("error1") ; return }
        guard let imageData = imageData else { print("error2") ; return }
        guard let audioURL = audioURL else { print("error3") ; return }
        guard let videoURL = videoRecorder.recordingURL else { print("error4") ; return }
        guard let title = experienceName else { print("error5") ; return }
        guard let location = coordinate else { print("error6") ; return }
     
        experienceController.createExperience(with: title, imageData: imageData, video: videoURL, audio: audioURL, location: location)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func recordButtonPressed(_ sender: UIButton) {
        videoRecorder.toggleVideoRecording()
    }
    
    func updateViews(){
        if videoRecorder.movieFileOutput.isRecording {
            recordProperties.setImage(UIImage(named: "Stop"), for: .normal)
            recordProperties.tintColor = .black
        } else {
            recordProperties.setImage(UIImage(named: "Record"), for: .normal)
            recordProperties.tintColor = .red
        }
    }
}

extension VideoViewController: VideoRecorderDelegate {
    func recorderDidChangeState(recorder: VideoRecorder) {
        updateViews()
    }
}
