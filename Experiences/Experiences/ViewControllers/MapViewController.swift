//
//  MapViewController.swift
//  Experiences
//
//  Created by Bhawnish Kumar on 6/5/20.
//  Copyright © 2020 Bhawnish Kumar. All rights reserved.
//


import UIKit
import MapKit

class MapViewController: UIViewController {
    
    var experienceController = ExperienceController()

       private let locManager = CLLocationManager()

       var detailView = MapDetailView()

       // MARK: - Actions


       // MARK: - Outlets

       @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


}
