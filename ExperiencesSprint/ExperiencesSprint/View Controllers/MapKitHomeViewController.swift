//
//  MapKitHomeViewController.swift
//  ExperiencesSprint
//
//  Created by Jarren Campos on 7/17/20.
//  Copyright © 2020 Jarren Campos. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

struct Location {
    var longitude: CLLocationDegrees
    var latitude: CLLocationDegrees
}

class MapKitHomeViewController: UIViewController {
    
    var postItem: Post!
    var postArray: [Post] = []
    let locationManager = CLLocationManager()
    var currentLongitude: CLLocationDegrees = 0
    var currentLatitude: CLLocationDegrees = 0


    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()

        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            print(self.currentLongitude)
            print(self.currentLatitude)
            
            var sampleData = [
                ["title": "This is a test", "latitude": self.currentLatitude, "longitude": self.currentLongitude]
             ]
            self.createAnnotations(locations: sampleData)


        }
    }
    
    func createAnnotations(locations: [[String: Any]]) {
        for location in locations {
            let annotations = MKPointAnnotation()
            annotations.title = location["title"] as? String
            annotations.coordinate = CLLocationCoordinate2D(latitude: location["latitude"] as! CLLocationDegrees, longitude: location["longitude"] as! CLLocationDegrees)
            mapView.addAnnotation(annotations)
        }
    }
    @IBAction func unwindToMapKitHome(_ sender: UIStoryboardSegue){}
}

extension MapKitHomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        self.currentLongitude = locValue.longitude
        self.currentLatitude = locValue.latitude
    }
}
