//
//  VideoRecordingViewController.swift
//  Experiences
//
//  Created by Alex Thompson on 5/17/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import AVFoundation
import MapKit

class VideoRecordingViewController: UIViewController {
    
    var userLocation: CLLocationCoordinate2D?
    var picture: Experience.Picture?
    var experienceTitle: String?
    var recordingURL: Experience.Audio?
    lazy private var captureSession = AVCaptureSession()
    lazy private var fileOutput = AVCaptureMovieFileOutput()
    var videoURL: URL?
    var player: AVPlayer!
    var mapViewController: MapViewController?

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
