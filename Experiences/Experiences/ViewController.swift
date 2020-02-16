//
//  ViewController.swift
//  Experiences
//
//  Created by Alex Shillingford on 2/14/20.
//  Copyright © 2020 shillwil. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mapView.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }


}

extension ViewController: MKMapViewDelegate {
    
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locationValue: CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locationValue.latitude) \(locationValue.longitude)")
        let userLocation = locations.last
        let span = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
        let viewRegion = MKCoordinateRegion(center: userLocation!.coordinate, span: span)
        self.mapView.setRegion(viewRegion, animated: true)
    }
    
}
