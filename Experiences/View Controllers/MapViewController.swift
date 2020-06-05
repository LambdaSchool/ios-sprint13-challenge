//
//  MapViewController.swift
//  Experiences
//
//  Created by Christian Lorenzo on 5/16/20.
//  Copyright © 2020 Christian Lorenzo. All rights reserved.
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
            preconditionFailure("Video is disabled, please review device restriction.")
        case .denied:
            preconditionFailure("You're not able to use app without giving permission via Settings > Privacy > Video.")
        case .authorized:
            break
        @unknown default:
            preconditionFailure("A new status code that was added that we need to handle.")
        }
    }
    
    private func requestVideoPermissions() {
        AVCaptureDevice.requestAccess(for: .video) { (isGranted) in
            guard isGranted else {
                preconditionFailure("Maybe create an alert later alerting to enable permissions for video.")
            }
        }
    }
    
    
    func updateViews() {
        guard let myExperience = experience else { return }
        mapView.addAnnotation(myExperience)
    }
    

 
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "NewExperienceSegue" {
               guard let newExperienceVC = segue.destination as? NewExperienceViewController else { return }
        userLocation = currentUserLocation()
        newExperienceVC.userLocation = userLocation
        newExperienceVC.mapVC = self
               
           }
       }
    }


extension Experience: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        geotag
    }
    
    var title: String? {
        experienceTitle
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
