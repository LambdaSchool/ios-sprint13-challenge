//
//  MapnotesMapViewController.swift
//  MapNotes
//
//  Created by Thomas Sabino-Benowitz on 7/10/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit


class MapNotesMapViewController: UIViewController, MKMapViewDelegate {
    
    var locationManager = CLLocationManager()
    var mapNoteController =  MapNoteController()

    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        determineCurrentLocation()
        mapView.delegate = self
        setupMapView()
//        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "QuakeView")
    }
    override func viewWillAppear(_ animated: Bool) {
           mapView.addAnnotations(mapNoteController.Mapnotes)
            mapView.showAnnotations(mapNoteController.Mapnotes, animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addImageNoteSegue" {
        guard let destinationVC = segue.destination as? PhotoDetailViewController else {return}
            
            destinationVC.coordinates = locationManager.location?.coordinate
        destinationVC.mapNoteController = mapNoteController
        }
        else if segue.identifier == "addAudioNoteSegue" {
            guard let destinationVC = segue.destination as? AudioDetailViewController else {return}
            destinationVC.coordinates = locationManager.location?.coordinate
         
            destinationVC.mapNoteController = mapNoteController.self
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        print(mapNoteController.Mapnotes)
    }
    
//        func determineCurrentLocation()
//        {
//            locationManager = CLLocationManager()
//            locationManager.delegate = self
//            locationManager.desiredAccuracy = kCLLocationAccuracyBest
//            locationManager.requestAlwaysAuthorization()
//
//            if CLLocationManager.locationServicesEnabled() {
//                //locationManager.startUpdatingHeading()
//                locationManager.startUpdatingLocation()
//            }
//        }
    
    private func centerMapOnLocation() {
        if let mapCenter = locationManager.location?.coordinate {
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region = MKCoordinateRegion(center: mapCenter, span: span)
            mapView.setRegion(region, animated: false)
        }
    }
    
    private func setupMapView () {
        mapView.delegate = self
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
        


 
    @IBAction func audioMapNoteTapped(_ sender: Any) {
        performSegue(withIdentifier: "addAudioNoteSegue", sender: Any?.self)
    }
    @IBAction func imageMapNoteTapped(_ sender: Any) {

        performSegue(withIdentifier: "addImageNoteSegue", sender: Any?.self)
    }
    
    
}
extension MapNotesMapViewController: CLLocationManagerDelegate {
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

