//
//  ExperiencesViewController.swift
//  Experiences
//
//  Created by Wyatt Harrell on 5/8/20.
//  Copyright © 2020 Wyatt Harrell. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ExperiencesViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Properties
    let experienceController = ExperienceController()
    let locationManager = CLLocationManager()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowAddExperienceSegue" {
            guard let AddExperienceVC = segue.destination as? AddExperienceViewController else { return }
            AddExperienceVC.experienceController = experienceController
            AddExperienceVC.locationManager = locationManager
        }
    }
    
    // MARK: - Private Methods
    

}

