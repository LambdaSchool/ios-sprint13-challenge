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


class MapViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    var userLocation: CLLocationCoordinate2D?
    private let regionInMeters: Double = 3500.0
    
    var experience: Experience? {
        didSet {
            updateViews()
        }
    }
    
    
    @IBOutlet var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
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
    
    
    func updateViews() {
        
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
