//
//  MapViewController.swift
//  SprintChallenge
//
//  Created by Elizabeth Wingate on 4/10/20.
//  Copyright © 2020 Lambda. All rights reserved.
//

import UIKit
import MapKit
import AVFoundation

class MapViewController: UIViewController {
   let experienceController = ExperienceController()
    
    @IBOutlet var mapview: MKMapView!
    @IBOutlet var postButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      // Do any additional setup after loading the view.
        
    }

    @IBAction func postButtonPressed(_ sender: Any) {
        print("Post Button was pressed.")
    }
    
}
