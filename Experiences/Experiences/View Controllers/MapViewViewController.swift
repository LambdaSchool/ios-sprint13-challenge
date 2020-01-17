//
//  MapViewViewController.swift
//  Experiences
//
//  Created by Brandi Bailey on 1/17/20.
//  Copyright © 2020 Brandi Bailey. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let location = CLLocationCoordinate2D(latitude: 33.812794,
            longitude: -117.9190981)

        let span = MKCoordinateSpan(latitudeDelta: 0.008, longitudeDelta: 0.008)
        let region = MKCoordinateRegion(center: location, span: span)
            mapView.setRegion(region, animated: true)
            
    }
    
    
}

extension MapViewViewController: MKMapViewDelegate {
    

}

