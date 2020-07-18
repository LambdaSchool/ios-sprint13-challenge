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

class MapKitHomeViewController: UIViewController {
    
    var postItem: Post = Post(title: "")
    var postArray: [Post] = []
    var helperInt = 0
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
        
        if helperInt > 0 {
        print(postItem.title)
        DispatchQueue.main.async {
            print(self.currentLongitude)
            print(self.currentLatitude)
            print(self.postItem.title)
            var sampleData = [
                ["title": self.postItem.title, "latitude": self.currentLatitude, "longitude": self.currentLongitude]
             ]
            self.createAnnotations(locations: sampleData)
        }
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
