//
//  ViewController.swift
//  Memories
//
//  Created by Samantha Gatt on 10/19/18.
//  Copyright © 2018 Samantha Gatt. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            NSLog("You need to alllow access")
        }
        
        userTrackingButton = MKUserTrackingButton(mapView: mapView)
        userTrackingButton.translatesAutoresizingMaskIntoConstraints = false
        mapView.addSubview(userTrackingButton)
        userTrackingButton.leftAnchor.constraint(equalTo: mapView.leftAnchor, constant: 20).isActive = true
        userTrackingButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -20).isActive = true
        
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "QuakeAnnotationView")
    }
    
    // MARK: - Properties
    
    private let locationManager = CLLocationManager()
    private var userTrackingButton: MKUserTrackingButton!
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    // MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "QuakeAnnotationView") as! MKMarkerAnnotationView
        annotationView.markerTintColor = .gray
        annotationView.glyphTintColor = .black
        annotationView.glyphImage = UIImage(named: "QuakeIcon")!
        
        annotationView.canShowCallout = true
        
        return annotationView
    }
}

