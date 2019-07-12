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
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        mapView.showsUserLocation = true
                let coordinates = mapView.userLocation.coordinate
                let currentLocation = coordinates
                let locationAnnotation = MKPointAnnotation()
                locationAnnotation.coordinate = currentLocation
                locationAnnotation.title = experience?.title //Pass in experience.title
        
               mapView.showAnnotations([locationAnnotation], animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print(location.coordinate)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // check to see if there is an experience
        //if there is then take the experiences title and assign it to the annotation.
        //use the current location as the coordinate for the annotation.
        //add the annotation
//
//        mapView.showsUserLocation = true
//        let coordinates = mapView.userLocation.coordinate
//        let currentLocation = coordinates
//        let locationAnnotation = MKPointAnnotation()
//        locationAnnotation.coordinate = currentLocation
//        locationAnnotation.title = "New Experience"
//
//       mapView.showAnnotations([locationAnnotation], animated: true)
        
        //show annotations
    }
    

 
  
    @IBOutlet weak var mapView: MKMapView!
    //Pass these in from a closure? in our camera view controller?
    var experience: Experience?
    var experienceController: ExperienceController?
    
}
