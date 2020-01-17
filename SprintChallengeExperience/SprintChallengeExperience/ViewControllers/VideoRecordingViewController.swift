//
//  VideoRecordingViewController.swift
//  SprintChallengeExperience
//
//  Created by Jerry haaser on 1/17/20.
//  Copyright © 2020 Jerry haaser. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class VideoRecordingViewController: UIViewController {
    
    private var captureSession: AVCaptureSession!
    private var recordOutput: AVCaptureMovieFileOutput!
    var experienceController: ExperienceController?
    var imageData: Data?
    var experienceTitle: String?
    var audioURL: URL?
    var coordinate: CLLocationCoordinate2D?
    var videoURL: URL?
    
    @IBOutlet weak var previewView: CameraPreviewView!
    @IBOutlet weak var recordButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCapture()
    }
    
    @IBAction func toggleRecord(_ sender: UIButton) {
    }
    
    @IBAction func saveExperienceTapped(_ sender: UIBarButtonItem) {
    }
    
    private func setupCapture() {
        let captureSession = AVCaptureSession()
        let device = bestCamera()
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
