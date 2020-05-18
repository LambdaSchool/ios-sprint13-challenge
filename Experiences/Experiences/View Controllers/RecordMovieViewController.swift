//
//  RecordMovieViewController.swift
//  Experiences
//
//  Created by Joshua Rutkowski on 5/17/20.
//  Copyright © 2020 Josh Rutkowski. All rights reserved.
//

import UIKit
import AVFoundation

class RecordMovieViewController: UIViewController {
    
    @IBOutlet var cameraView: CameraPreviewView!
    @IBOutlet var recordButton: UIButton!
    // MARK: - Properties
    var experienceController: ExperienceController?
    var experience: Experience?
    var video = ""
    lazy private var captureSession = AVCaptureSession()
    lazy private var fileOutput = AVCaptureMovieFileOutput()
    var experienceTitle: String?
    var latitude: Double?
    var longitude: Double?
    var audioExtension: String?
    var photoExtension: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func addVideo() {
        
        guard let title = experienceTitle,
            let lat = latitude,
            let long = longitude else { return }
        
        experienceController?.createExperience(title: title, latitude: lat, longitude: long, videoExtension: video, audioExtension: audioExtension ?? "", photoExtension: photoExtension ?? "")
        navigationController?.popToRootViewController(animated: true)
    }
    

    @IBAction func recordButtonTapped(_ sender: Any) {
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        addVideo()
    }
    
}
