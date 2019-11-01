//
//  ExpMapViewController.swift
//  Experiences
//
//  Created by Ciara Beitel on 11/1/19.
//  Copyright © 2019 Ciara Beitel. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ExpMapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    var experienceController: ExperienceController = ExperienceController()
    let annotationReuseIdentifier = "ExpAnnotation"
    
    @IBOutlet weak var experiencesMapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        experiencesMapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        let status = CLLocationManager.authorizationStatus()
        switch status {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .authorizedWhenInUse:
                locationManager.requestLocation()
            default:
            break
        }
        experiencesMapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: annotationReuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        experiencesMapView.removeAnnotations(experiencesMapView.annotations)
        let annotations = experiencesMapView.annotations.compactMap({ $0 as? ExperienceAnnotation })
            experiencesMapView.addAnnotations(annotations)
        experiencesMapView.addAnnotations(annotations)
    }
        
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationReuseIdentifier, for: annotation) as? MKMarkerAnnotationView else { return nil }
        annotationView.titleVisibility = .adaptive
        annotationView.subtitleVisibility = .adaptive
        return annotationView
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NSLog("Location manager failed with error: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else { return }
        locationManager.requestLocation()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowNewExpSegue" {
            let destinationVC = segue.destination as? UINavigationController
            
            let nextVC = destinationVC?.viewControllers[0] as? ExperienceViewController
            nextVC?.experienceController = experienceController
        }
    }
}
