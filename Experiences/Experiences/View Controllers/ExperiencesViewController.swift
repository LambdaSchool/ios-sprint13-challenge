//
//  ExperiencesViewController.swift
//  Experiences
//
//  Created by Sameera Roussi on 7/29/19.
//  Copyright © 2019 Sameera Roussi. All rights reserved.
//

import UIKit
import MapKit

class ExperiencesViewController: UIViewController {

    // MARK: - Properties
    private let locationManager = CLLocationManager()
    private var currentCoordinate: CLLocationCoordinate2D?
    let status = CLLocationManager.authorizationStatus()
    var drop = false
    
    // MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - View states
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar
        self.navigationController?.navigationBar.isHidden = true;
        
        if drop {
            configureLocationServices()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false;
        drop = true
    }
    
    // MARK: - Functions
    private func configureLocationServices() {
        locationManager.delegate = self
        
        // Save the authorizaation status in a variable
//        let status = CLLocationManager.authorizationStatus()
//
//        // Request always authorization from user to track their location.
//        if status == .notDetermined {
//            locationManager.requestWhenInUseAuthorization()
//        } else if status == .authorizedWhenInUse {
        if status == .authorizedWhenInUse {
            beginLocationUpdates(locationManager: locationManager)
        }
    }
    
    // Begin tracking location
    private func beginLocationUpdates(locationManager: CLLocationManager) {
        mapView.showsUserLocation = false
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    // Define a region
    private func zoomToLatestLocation(with coordinate: CLLocationCoordinate2D) {
        let zoomRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 10_000, longitudinalMeters: 10_000)
        mapView.setRegion(zoomRegion, animated: true)
        currentCoordinate = coordinate
        print("Current coordinate = \(String(describing: currentCoordinate))")
    }
    
    private func addAnnotations() {
        let experienceLocation = MKPointAnnotation()
        experienceLocation.title = "A New Experience"
        experienceLocation.subtitle = "Enjoy your day"
        experienceLocation.coordinate = currentCoordinate!
        
        mapView.addAnnotation(experienceLocation)
    }

    // MARK: - Actions
    @IBAction func addNewExperienceButtonTapped(_ sender: Any) {
    }
}


// MARK: - Extensions
extension ExperiencesViewController: CLLocationManagerDelegate {
    // Function to track location changes
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.first else { return }
        
        if currentCoordinate == nil {
            zoomToLatestLocation(with: latestLocation.coordinate)
            addAnnotations()
        }
        
        currentCoordinate = latestLocation.coordinate
    }
}
