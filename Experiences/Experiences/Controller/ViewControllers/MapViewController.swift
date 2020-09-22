//
//  MapViewController.swift
//  Experiences
//
//  Created by Lambda_School_loaner_226 on 9/14/20.
//  Copyright © 2020 Experiences. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
//    var mapViewController = MapViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "ExperienceView")
        
//        let myExperience = Experience(name: "Flowers", latitude: locationManager.location?.coordinate.latitude, longitude: locationManager.location?.coordinate.longitude)
//        mapView.addAnnotation(myExperience)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            locationManager.stopUpdatingLocation()
            render(location)
        }
    }
    
    func render(_ location: CLLocation) {
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        mapView.addAnnotation(pin)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToNewExperience" {
            if let newExperienceVC = segue.destination as? NewExperienceDetailViewController {
                newExperienceVC.mapDelegate = self
            }
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {
     
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

//        guard let experience = annotation as? Experience else {
//            fatalError("Only Experience objects are supported right now")
//        }
        
        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "ExperienceView") as? MKMarkerAnnotationView else { return nil}

//        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "ExperienceView", for: experience) as? MKMarkerAnnotationView else {
//            fatalError("Missing a registered map annotation view. Have you done this in the viewDidLoad?")
//        }
        annotationView.annotation = annotation
        return annotationView
    }
}

extension MapViewController: PassExperience {
    func newExperience(experience: Experience) {
        mapView.addAnnotation(experience)
        navigationController?.popViewController(animated: true)
    }
}
