//
//  MapVC.swift
//  Experiences
//
//  Created by Cora Jacobson on 11/7/20.
//

import UIKit
import MapKit

class MapVC: UIViewController {

    @IBOutlet private var mapView: MKMapView!
    
    fileprivate let locationManager = CLLocationManager()
    var span = MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15)
    var userLocation: CLLocationCoordinate2D?
    var pins: [MKAnnotation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMap()
    }
    
    private func setUpMap() {
        mapView.removeAnnotations(pins)
        pins = ExperienceController.shared.experiences
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
        mapView.showAnnotations(pins, animated: true)
    }

}

extension MapVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last! as CLLocation
        let currentLocation = location.coordinate
        userLocation = currentLocation
        let coordinateRegion = MKCoordinateRegion(center: currentLocation, span: span)
        mapView.setRegion(coordinateRegion, animated: true)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
