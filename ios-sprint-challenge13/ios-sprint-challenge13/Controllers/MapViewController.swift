//
//  MapViewController.swift
//  ios-sprint-challenge13
//
//  Created by David Doswell on 10/19/18.
//  Copyright © 2018 David Doswell. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    private let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let annotationView = MKAnnotationView()
        
        return annotationView
    }

}
