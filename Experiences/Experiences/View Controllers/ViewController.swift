//
//  ViewController.swift
//  Experiences
//
//  Created by Lambda_School_Loaner_214 on 11/1/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {
    
    let locationManager = CLLocationManager()

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewWillAppear(_ animated: Bool) {
        centerMapOnLocation()
        let annotations = mapView.annotations.compactMap({ $0 as? Experience })
        mapView.addAnnotations(annotations)
    }
    
    private func centerMapOnLocation() {
        if let mapCenter = locationManager.location?.coordinate {
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region = MKCoordinateRegion(center: mapCenter, span: span)
            mapView.setRegion(region, animated: false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
    }
    
    private func setupMapView () {
        mapView.delegate = self
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "ExperienceView")
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            locationManager.requestLocation()
            centerMapOnLocation()
        default:
            break
        }
    }
    
    @IBAction func longPress(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let alert = UIAlertController(title: "Add Experience?", message: "Do you want to add an Experience here?", preferredStyle: .actionSheet)
            let actionOK = UIAlertAction(title: "Yes", style: .default) { (_) in
                //TODO: Add annotation
            }
            let actionCancel = UIAlertAction(title: "No", style: .destructive, handler: nil)
            alert.addAction(actionOK)
            alert.addAction(actionCancel)
            present(alert, animated: true, completion: nil)
        }
    }
}

extension ViewController: MKMapViewDelegate {
    
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NSLog("Location manager failed with error: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else { return }
        locationManager.requestLocation()
    }
}
