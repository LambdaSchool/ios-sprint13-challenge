//
//  ExperienceMapViewController.swift
//  ios-sprint13-challenge
//
//  Created by Conner on 10/19/18.
//  Copyright © 2018 Conner. All rights reserved.
//

import UIKit
import MapKit

class ExperienceMapViewController: UIViewController {
    @IBOutlet var mapView: MKMapView!
    
    private let geoCoder = CLGeocoder()
    lazy var locationManager: CLLocationManager = {
        let result = CLLocationManager()
        result.delegate = self
        return result
    }()
    private var experiences = [Experience]() {
        didSet {
            DispatchQueue.main.async {
                self.mapView.addAnnotations(self.experiences)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "ExperienceAnnotationView")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddExperienceSegue" {
            
        }
    }
}

extension ExperienceMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let experience = annotation as? Experience else { return nil }
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "ExperienceAnnotationView", for: experience) as! MKMarkerAnnotationView
        
        return annotationView
    }
}

extension ExperienceMapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                NSLog("Error geocoding location: \(error)")
                return
            }
            
            guard let placemark = placemarks?.first else { return }
            // Get longitude and latitude from placemark and create CLLocation for passing
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NSLog("Failed getting location with error: \(error)")
        return
    }
}
