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

class MapViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // check to see if there is an experience
        //if there is then take the experiences title and assign it to the annotation.
        //use the current location as the coordinate for the annotation.
        //add the annotation
        let currentLocation = CLLocationCoordinate2D(latitude: 37.819722, longitude: -122.478611) //SF
        let locationAnnotation = MKPointAnnotation()
        locationAnnotation.coordinate = currentLocation
        locationAnnotation.title = "New Experience"
        
       mapView.showAnnotations([locationAnnotation], animated: true)
        
        //show annotations
    }
    

 
  
    @IBOutlet weak var mapView: MKMapView!
    var experience: Experience?
    var experienceController = ExperienceController()
    
}
