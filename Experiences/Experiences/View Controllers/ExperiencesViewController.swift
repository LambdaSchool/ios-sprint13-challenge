//
//  ExperiencesViewController.swift
//  Experiences
//
//  Created by Moses Robinson on 3/22/19.
//  Copyright © 2019 Moses Robinson. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ExperiencesViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUserLocation()
    }
    
    private func getUserLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    @IBAction func startExperience(_ sender: Any) {
        
        guard let latitude = locationManager.location?.coordinate.latitude,
            let longitude = locationManager.location?.coordinate.longitude else { return }
        
        let locationCoordinates = CLLocationCoordinate2DMake(latitude, longitude)
        
        experienceController.location = locationCoordinates
        
        locationManager.stopUpdatingLocation()
        
        performSegue(withIdentifier: "CreateExperience", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreateExperience" {
            guard let destination = segue.destination as? UINavigationController, let vcDestination = destination.topViewController as? PhotoAudioViewController else { return }
            
            vcDestination.experienceController = experienceController
        }
    }
    
    // MARK: - Properties
    
    var experienceController = ExperienceController()
    
    let locationManager =  CLLocationManager()
    
    @IBOutlet var mapView: MKMapView!
}

