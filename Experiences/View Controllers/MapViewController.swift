//
//  MapViewController.swift
//  Experiences
//
//  Created by macbook on 12/6/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    //MARK: Properties
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 10_000
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    // Zoom in to user's are by regionInMeters
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    // Checking if location services are even permited in the entire device
    func checkLocationServices() {
        
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // TODO: Show alert letting the user know we need permission
        }
    }
    
    func checkLocationAuthorization() {
        
        switch CLLocationManager.authorizationStatus() {
            
        case .authorizedWhenInUse :
            mapView.showsUserLocation = true // Display current location
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation() // Updates location as it moves
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization() // asking fro permission
        case .restricted:
            // TODO: Show alert letting know whats up
            break
        case .denied:
            // TODO: Show alert instructing them how to turn on permission
            break
        case .authorizedAlways:
            break
        @unknown default:
            break
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    


}

extension MapViewController: CLLocationManagerDelegate {
    
    // This func runs every time the user moves (re-locates)
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else { return }
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        
        mapView.setRegion(region, animated: true)
    }
    
    // Runs everytime the authirization changes.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        checkLocationAuthorization()
    }
}
