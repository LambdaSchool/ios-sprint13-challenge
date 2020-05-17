//
//  MapViewController.swift
//  Experiences
//
//  Created by Alex Thompson on 5/16/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import MapKit
import AVFoundation
import CoreLocation

class MapViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    var userLocation: CLLocationCoordinate2D?
    private let regionInMeters: Double = 35000.0
    
    var experience: Experience? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet var mapView: MKMapView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        requestCameraPermission()
    }
    
    func currentUserLocation() -> CLLocationCoordinate2D {
        guard let currentLocation = locationManager.location?.coordinate else { return CLLocationCoordinate2D() }
        return currentLocation
    }
    
    private func requestCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            requestCameraPermission()
            
        case .restricted:
            preconditionFailure("Video is disabled, please review device restrictions.")
        case .denied:
            preconditionFailure("You are not able to use the app without giving permission via Settins > Privacy > Video.")
        case .authorized: break
        @unknown default:
            preconditionFailure("A new status code that was added that we need to handle.")
        }
    }
    
    private func requestVideoPermissions() {
        AVCaptureDevice.requestAccess(for: .video) { isGranted in
            guard isGranted else {
                preconditionFailure("Maybe create an alert later to tell user to enable permissions for video or camera :)")
            }
        }
    }
    
    func updateViews() {
        guard let myExperience = experience else { return }
        mapView.addAnnotation(myExperience)
    }
    

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ImageSegue" {
            guard let imageSelectionVC = segue.destination as? NewExperienceViewController else { return }
            
            userLocation = currentUserLocation()
            imageSelectionVC.userLocation = userLocation
            imageSelectionVC.mapVC = self
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        
        mapView.setRegion(region, animated: true)
    }
}

extension MapViewController: MKMapViewDelegate {
    
}
