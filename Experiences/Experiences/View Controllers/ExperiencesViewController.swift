//
//  ExperiencesViewController.swift
//  Experiences
//
//  Created by Moses Robinson on 3/22/19.
//  Copyright © 2019 Moses Robinson. All rights reserved.
//

import UIKit
import MapKit

class ExperiencesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userLocation = mapView.userLocation.coordinate
    }


    // MARK: - Properties
    
    private var userLocation: CLLocationCoordinate2D?
    
    @IBOutlet var mapView: MKMapView!
}

