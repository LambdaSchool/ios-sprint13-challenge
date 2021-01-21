//
//  MapViewController.swift
//  Experiences
//
//  Created by Shawn Gee on 5/8/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    // MARK: - Private Properties
    
    let experienceController = ExperienceController()

    // MARK: - IBOutlets
    
    @IBOutlet private weak var mapView: MKMapView! { didSet { setUpMapView() }}
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateExperienceAnnotations()
    }
    
    // MARK: - Private Methods
    
    private func setUpMapView() {
        mapView.delegate = self
        updateExperienceAnnotations()
    }
    
    private func updateExperienceAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(experienceController.experiences)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let experienceVC = segue.destination as? ExperienceViewController {
            experienceVC.experienceController = experienceController
            experienceVC.experience.latitude = mapView.centerCoordinate.latitude
            experienceVC.experience.longitude = mapView.centerCoordinate.longitude
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    // TODO: Implement custom annotation views
}


