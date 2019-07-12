//
//  MapViewController.swift
//  Experiences
//
//  Created by Victor  on 7/12/19.
//  Copyright © 2019 Victor . All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    // MAvar - Properties
    
    var experienceController = ExperienceController()
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "AnnotiationView")
        self.mapView.addAnnotations(experienceController.experiences)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.mapView.addAnnotations(experienceController.experiences)
    }
    
    // MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let experience = annotation as? Experience else { return nil }
        
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "AnnotiationView", for: experience) as! MKMarkerAnnotationView
        annotationView.markerTintColor = .red
        annotationView.canShowCallout = true
        
        return annotationView
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreateExperience" {
            //logic
        }
    }
    
}
