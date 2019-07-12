//
//  VideoRecordingViewController.swift
//  Experiences
//
//  Created by Hayden Hastings on 7/12/19.
//  Copyright © 2019 Hayden Hastings. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import CoreLocation

class VideoRecordingViewController: UIViewController {

    let experienceController = ExperienceController()
    var imageURL: URL?
    var titleTextString: String?
    var audioURL: URL?
    var videoURL: URL?
    var cLLocation: CLLocationCoordinate2D?
    var captureSession = AVCaptureSession()
    var recordOutput = AVCaptureMovieFileOutput()
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
