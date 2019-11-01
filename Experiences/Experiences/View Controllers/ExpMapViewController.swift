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
    var experienceController: ExperienceController!
    let annotationReuseIdentifier = "ExpAnnotation"
    
    @IBOutlet weak var experiencesMapView: MKMapView!
    
    
    @IBAction func addNewExpButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "ShowNewExpSegue", sender: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
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
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: annotationReuseIdentifier)
    }
    
    override func viewWillAppear() {
        super.viewWillAppear(animated)
        mapView.removeAnnotations(mapView.annotations)
        let annotations = mapView.annotations.compactMap({ $0 as? (your model object type) })
            mapView.addAnnotations(annotations)
        mapView.addAnnotations(annotations)
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
            let destinationVC = segue.destination as? ExperienceViewController
            destinationVC?.expController = expController
        }
    }
}
