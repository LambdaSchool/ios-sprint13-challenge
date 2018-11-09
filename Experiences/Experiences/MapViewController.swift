//
//  MapViewController.swift
//  Experiences
//
//  Created by Daniela Parra on 11/9/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        
        mapView.delegate = self
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "ExperienceAnnotationView")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        let navVC = segue.destination as! UINavigationController
        
        guard let nextVC = navVC.viewControllers.first as? AddNewExperienceViewController else { return }
        
        nextVC.experienceController = experienceController
        nextVC.coordinate = mapView.userLocation.coordinate
        nextVC.mapView = mapView
    }
    
    let locationManager = CLLocationManager()
    var experienceController = ExperienceController()
    
    @IBOutlet weak var mapView: MKMapView!
}
