//
//  RecordersViewController.swift
//  Experiences
//
//  Created by Christian Lorenzo on 5/16/20.
//  Copyright © 2020 Christian Lorenzo. All rights reserved.
//

import UIKit
import AVFoundation
import MapKit

class RecordersViewController: UIViewController {
    
    var mapViewController: MapViewController?
    var userLocation: CLLocationCoordinate2D?
    var picture: Experience.Picture?
    var audioRecorder: AVAudioRecorder?
    var experienceTitle: String?
    var recordingURL: URL?
    
    @IBOutlet weak var recordAudioOutlet: UIButton!
    @IBOutlet weak var recordVideoOutlet: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        recordAudioOutlet.layer.cornerRadius = 20
        recordAudioOutlet.layer.borderColor = UIColor.black.cgColor
        recordAudioOutlet.layer.borderWidth = 1
        recordVideoOutlet.isEnabled = false
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
