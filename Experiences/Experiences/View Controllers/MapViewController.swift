//
//  MapViewController.swift
//  Experiences
//
//  Created by Linh Bouniol on 10/19/18.
//  Copyright © 2018 Linh Bouniol. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    var experienceController = ExperienceController()
    var currentAnnotations: [Experience] = []
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mapView.removeAnnotations(mapView.annotations)
        
        mapView.addAnnotations(experienceController.experiences)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let experienceVC = segue.destination as? ExperienceViewController {
            experienceVC.experienceController = experienceController
        }
    }
}
