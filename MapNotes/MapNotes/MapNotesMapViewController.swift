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


class MapNotesMapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var mapNoteController =  MapNoteController()

    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        determineCurrentLocation()
        mapView.delegate = self
        for mapnote in mapNoteController.Mapnotes {
            mapView.addAnnotation(mapnote)
        }
//        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "QuakeView")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addImageNoteSegue" {
        guard let destinationVC = segue.destination as? PhotoDetailViewController else {return}
            
            destinationVC.coordinates.latitude = locationManager.location?.coordinate.latitude as! CLLocationDegrees
            destinationVC.coordinates.longitude = locationManager.location?.coordinate.longitude as! CLLocationDegrees
        destinationVC.mapNoteController = mapNoteController
        }
        else if segue.identifier == "addAudioNoteSegue" {
            guard let destinationVC = segue.destination as? AudioDetailViewController else {return}
            destinationVC.coordinates.latitude = mapView.centerCoordinate.latitude
            destinationVC.coordinates.longitude = mapView.centerCoordinate.longitude
            destinationVC.mapNoteController = mapNoteController.self
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        print(mapNoteController.Mapnotes)
    }
    
        func determineCurrentLocation()
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            
            if CLLocationManager.locationServicesEnabled() {
                //locationManager.startUpdatingHeading()
                locationManager.startUpdatingLocation()
            }
        }
        
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        }
        
    private func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
        {
            print("Error \(error)")
        }

 
    @IBAction func audioMapNoteTapped(_ sender: Any) {
        performSegue(withIdentifier: "addAudioNoteSegue", sender: Any?.self)
    }
    @IBAction func imageMapNoteTapped(_ sender: Any) {

        performSegue(withIdentifier: "addImageNoteSegue", sender: Any?.self)
    }
    
}


