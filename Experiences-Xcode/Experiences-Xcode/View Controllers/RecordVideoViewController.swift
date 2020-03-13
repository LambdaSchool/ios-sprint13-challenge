//
//  RecordVideoViewController.swift
//  Experiences-Xcode
//
//  Created by Austin Potts on 3/13/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import AVFoundation

protocol CameraViewControllerDelegate {
    func setRecordURL(_ recordURL: URL)
    func saveWithNoVideo()
}

class RecordVideoViewController: UIViewController {

    @IBOutlet weak var videoView: CameraView!
    @IBOutlet weak var recordButton: UIButton!
    
    var experienceController: ExperienceController!
    var delegate: CameraViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func recordTapped(_ sender: Any) {
    }
    
    
    
    @IBAction func saveTapped(_ sender: Any) {
    }
    
}
