//
//  VideoRecordingViewController.swift
//  Experiences
//
//  Created by Chris Gonzales on 4/10/20.
//  Copyright © 2020 Chris Gonzales. All rights reserved.
//

import UIKit

class VideoRecordingViewController: UIViewController {
    
    // MARK: - Properties
    
    var experienceController: ExperienceController?
    var geoTag: GeoTag?
    var descriptionText: String?
    
    // MARK: -  Outles

    @IBOutlet weak var recordButton: UIButton!
    
    // MARK: - Actions
    
    @IBAction func saveTapped(_ sender: Any) {
    }
    @IBAction func recordTapped(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
}
