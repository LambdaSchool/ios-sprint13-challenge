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
        
        mapView.delegate = self
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "ExperienceView")
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mapView.addAnnotations(experienceController.experiences)
    }

    @IBAction func startExperience(_ sender: Any) {
        locationManager.startUpdatingLocation()
        
        guard let latitude = locationManager.location?.coordinate.latitude,
            let longitude = locationManager.location?.coordinate.longitude else { return }
        
        let locationCoordinates = CLLocationCoordinate2DMake(latitude, longitude)
        
        experienceController.location = locationCoordinates
        
        locationManager.stopUpdatingLocation()
        
        performSegue(withIdentifier: "CreateExperience", sender: nil)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let experience = annotation as? Experience else { return nil }

        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "ExperienceView", for: experience) as? MKMarkerAnnotationView else { return nil }
        
        return annotationView
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreateExperience" {
            guard let destination = segue.destination as? UINavigationController, let vcDestination = destination.topViewController as? PhotoAudioViewController else { return }
            
            vcDestination.experienceController = experienceController
        }
    }
    
    // MARK: - Properties
    
    let experienceController = ExperienceController()
    
    let locationManager =  CLLocationManager()
    
    @IBOutlet var mapView: MKMapView!
}

