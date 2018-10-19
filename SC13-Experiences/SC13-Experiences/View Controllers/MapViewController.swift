//
//  MapViewController.swift
//  SC13-Experiences
//
//  Created by Andrew Dhan on 10/19/18.
//  Copyright © 2018 Andrew Liao. All rights reserved.
//

import UIKit
import MapKit

private let segueIdentifier = "AddExperience"

class MapViewController: UIViewController, MKMapViewDelegate {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        experienceAnnotations = experienceController.experiences
        mapView.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: "ExperienceAnnotation")
        mapView.delegate = self
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let experienceAnnotation = mapView.dequeueReusableAnnotationView(withIdentifier: "ExperienceAnnotation", for: annotation) as! MKMarkerAnnotationView
        if let title = annotation.title {
            experienceAnnotation.glyphText = title
        }
        return experienceAnnotation
    }
    
    
    //MARK: - Properties
    private var experienceAnnotations = [MKAnnotation]()
    private let experienceController = ExperienceController.shared
    @IBOutlet weak var mapView: MKMapView!
    
}
