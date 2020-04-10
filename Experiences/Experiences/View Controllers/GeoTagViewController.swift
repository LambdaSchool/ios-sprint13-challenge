//
//  GeoTagViewController.swift
//  Experiences
//
//  Created by Chris Gonzales on 4/10/20.
//  Copyright © 2020 Chris Gonzales. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class GeoTagViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: - Properties
    
    let experienceController = ExperienceController()
    
    var geoTag: GeoTag?{
        didSet{
            guard let geoTag = geoTag else { return }
            let coordinateSpan = MKCoordinateSpan(latitudeDelta: 0.1,
                                                  longitudeDelta: 0.1)
            let region = MKCoordinateRegion(center: geoTag.coordinate,
                                            span: coordinateSpan)
            self.mapView.setRegion(region,
                                   animated: true)
            mapView.addAnnotation(geoTag)
            
        }
    }
    var locationManager: CLLocationManager?
    
    // MARK: - Outlets
    
    @IBOutlet var mapView: MKMapView!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.register(MKMarkerAnnotationView.self,
                         forAnnotationViewWithReuseIdentifier: "GeoTagView")
        locationManager = CLLocationManager()
        guard let locationManager = locationManager else { return }
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ConstantValues.entrySegue {
            guard let entryVC = segue.destination as? EntryViewController else { return }
            entryVC.experienceController = experienceController
            entryVC.geoTag = geoTag
        }
    }
}

extension GeoTagViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
            guard let locationManager = locationManager else { return }
            let location: CLLocation = locations[0]
            print("\(location)")
            let lat = location.coordinate.latitude
            let long = location.coordinate.longitude
            geoTag = GeoTag(longitude: long,
                            latitude: lat)
            
        }
        
    }
}
