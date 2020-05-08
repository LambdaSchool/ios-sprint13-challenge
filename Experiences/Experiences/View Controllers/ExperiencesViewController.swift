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
        updateViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateViews()
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
    private func updateViews() {
        self.mapView.addAnnotations(experienceController.experiences)
        guard let xp = experienceController.experiences.first else { return }
        
        let span = MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2)
        let region = MKCoordinateRegion(center: xp.coordinate, span: span)
        self.mapView.setRegion(region, animated: true)
    }

}

