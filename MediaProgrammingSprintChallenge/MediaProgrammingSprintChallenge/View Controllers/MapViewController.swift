//
//  MapViewController.swift
//  MediaProgrammingSprintChallenge
//
//  Created by Nathanael Youngren on 3/29/19.
//  Copyright © 2019 Nathanael Youngren. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: "MomentAnnotationView")
        
        checkLocationServices()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        momentController.fetchMoments { (moments, error) in
            if let error = error {
                print("Error fetching moments: \(error).")
                return
            }
            
            guard let moments = moments else { return }
            
            self.mapView.addAnnotations(moments)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let moment = annotation as? Moment else { return nil }
        
        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "MomentAnnotationView", for: moment) as? MKMarkerAnnotationView else { return nil }
        
        annotationView.glyphTintColor = .white
        annotationView.markerTintColor = .lightGray
        
        annotationView.canShowCallout = true
        
        let detailView = MomentDetailView(frame: .zero)
        
        detailView.moment = moment
        
        annotationView.detailCalloutAccessoryView = detailView
        
        return annotationView
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddMomentSegue" {
            guard let vc = segue.destination as? ImageAndAudioViewController else { return }
            vc.momentController = momentController
            vc.longitude = longitude
            vc.latitude = latitude
        }
    }
    
    @IBOutlet weak var mapView: MKMapView!
    
    let momentController = MomentController()
    let locationManager = CLLocationManager()
    
    var longitude: Double?
    var latitude: Double?
}

extension MapViewController: CLLocationManagerDelegate {
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            checkLocationAuthorization()
        }
    }
    
    func checkLocationAuthorization() {
        
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            let location = mapView.userLocation
            
            longitude = Double(location.coordinate.longitude)
            latitude = Double(location.coordinate.latitude)
            
        default:
            break
        }
    }
}
