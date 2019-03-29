//
//  ViewController.swift
//  Experiences
//
//  Created by Julian A. Fordyce on 3/29/19.
//  Copyright © 2019 Julian A. Fordyce. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        requestPermission()
    }
    
    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
        
    }

    @IBAction func addExperience(_ sender: Any) {
        
    }
    
    
    
    // MARK: - Properties
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addButton: UIButton!
    let locationManager = CLLocationManager()
    var location: CLLocationCoordinate2D!
    
    
}

