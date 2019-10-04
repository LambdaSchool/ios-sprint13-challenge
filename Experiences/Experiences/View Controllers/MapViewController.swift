//
//  MapViewController.swift
//  Experiences
//
//  Created by Marlon Raskin on 10/4/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!

    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getUserCurrentLocation()
    }

    @IBAction func currentLocationTapped(_ sender: UIButton) {
        getUserCurrentLocation()
    }

    func getUserCurrentLocation() {
        guard let userCurrentLocation = mapView.userLocation.location else { return }
        let coordinate = userCurrentLocation.coordinate
        let coordinateCenter = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: coordinateCenter, span: span)
        mapView.setRegion(region, animated: true)
    }

}

extension MapViewController: CLLocationManagerDelegate {

}
