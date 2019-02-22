//
//  GeoViewController.swift
//  LambdaTimeline
//
//  Created by Sergey Osipyan on 2/21/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class GeoViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    

    @IBOutlet weak var mapView: MKMapView!
    private let locationManager = CLLocationManager()
    var curentLocation: CLLocationCoordinate2D?
    
    let experienceController = ExperienceController.shared

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            NSLog("You need to alllow access")
        }
        
    
        let userTrackingButton = MKUserTrackingButton(mapView: mapView)
        userTrackingButton.translatesAutoresizingMaskIntoConstraints = false
        mapView.addSubview(userTrackingButton)

        userTrackingButton.rightAnchor.constraint(equalTo: mapView.rightAnchor, constant: -5).isActive = true
        userTrackingButton.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 95).isActive = true

       
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "AnnotationView")
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if #available(iOS 8.0, *) {
            locationManager.requestAlwaysAuthorization()
        }
        locationManager.startUpdatingLocation()
    }
     
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "AnnotationView") as! MKMarkerAnnotationView
        annotationView.markerTintColor = .gray
        annotationView.glyphTintColor = .black
        
        return annotationView
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last! as CLLocation
        
        curentLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: curentLocation!, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        
        //set region on the map
        self.mapView.setRegion(region, animated: true)
        self.locationManager.stopUpdatingLocation()
        
    }
    
    func updateView() {
        
        let anotations = mapView.annotations
        
        
        mapView.removeAnnotations(anotations)
        mapView.addAnnotations(experienceController.experiences)
    }
    

}
