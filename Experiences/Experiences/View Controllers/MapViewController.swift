//
//  MapViewController.swift
//  Experiences
//
//
//  Created by Rick Wolter on 2/14/20.
//  Copyright © 2020 Devshop7. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var experienceController: ExperienceController?

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "ExperienceView")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadExperiences()
    }
    
    private func loadExperiences() {
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(experienceController?.experiences ?? [])
        
        print(mapView.annotations.count)
    }

}
