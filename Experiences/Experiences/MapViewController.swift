//
//  MapViewController.swift
//  Experiences
//
//  Created by Nonye on 7/10/20.
//  Copyright © 2020 Nonye Ezekwo. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MapViewDelegate {
    
    var experienceController = ExperienceController()
    
    private let locationManager = CLLocationManager()
    
    var detailView = MapDetailView()
    
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startLocationManager()
        mapView.delegate = self
        
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "ExperienceView")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        refreshAnnotations()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddExperience" {
            guard let vc = segue.destination as? ExperienceViewController else { return }
            vc.experienceController = experienceController
            vc.delegate = self
            if let exp = sender as? Experience {
                vc.experience  = exp
            }
        }
    }
    
    // MARK: - Public
    func myLocation() -> (latitude: Double, longitude: Double){
        
        var lat = locationManager.location?.coordinate.latitude ?? 0.0
        var long = locationManager.location?.coordinate.longitude ?? 0.0
        
        return (latitude: lat, longitude: long)
    }
    
    func invokeViewExperience(_ exp: Experience) {
        performSegue(withIdentifier: "AddExperience", sender: exp)
    }
    
    // MARK: - Private
    private func startLocationManager() {
        locationManager.requestAlwaysAuthorization()

        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    private func addAnnotations() {
        mapView.addAnnotations(experienceController.experiences)
        
        guard let post = self.experienceController.experiences.last else { return }
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: post.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    private func refreshAnnotations() {
        
        mapView.removeAnnotations(mapView.annotations)
        
        DispatchQueue.main.async {
            self.addAnnotations()
        }
    }
}

protocol MapViewDelegate {
    
    func invokeViewExperience(_ exp: Experience)
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let experience = annotation as? Experience else {
            fatalError("Unable to add experience")
        }
        
        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "ExperienceView", for: annotation) as? MKMarkerAnnotationView else {
            fatalError("Missing a view")
        }
        
        annotationView.glyphImage = nil
        annotationView.canShowCallout = true
        detailView = MapDetailView()
        detailView.delegate = self
        detailView.experience = experience
        annotationView.detailCalloutAccessoryView = detailView
        
        return annotationView
    }

}
