//
//  MapViewController.swift
//  Experiences
//
//  Created by Thomas Cacciatore on 7/12/19.
//  Copyright © 2019 Thomas Cacciatore. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard let experiences = experienceController?.experiences else { return }
        mapView.showAnnotations(experiences, animated: true)
    }
    

 
  
    @IBOutlet weak var mapView: MKMapView!
   
    var experience: Experience?
    var experienceController: ExperienceController?
    
}
