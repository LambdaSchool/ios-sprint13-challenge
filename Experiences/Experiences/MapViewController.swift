//
//  MapViewController.swift
//  Experiences
//
//  Created by Ryan Murphy on 7/12/19.
//  Copyright © 2019 Ryan Murphy. All rights reserved.
// git not working ... 

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    let locationHelper = LocationHelper()
    let experienceController = ExperienceController()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationHelper.requestLocationAuthorization()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "ExperienceAnnotationView")
        
        let experiences = experienceController.experiences
        mapView.addAnnotations(experiences)
        
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let experience = annotation as? Experience else { return nil }
        
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "ExperienceAnnotationView", for: experience) as! MKMarkerAnnotationView
        
        annotationView.glyphTintColor = .red
        annotationView.canShowCallout = true
        
        return annotationView
    }

    @IBAction func newExperiencePressed(_ sender: Any) { self.performSegue(withIdentifier: "AddExperience", sender: sender)
        
    }
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddExperience" {
            if let navigationController = segue.destination as? UINavigationController {
                if let viewController = navigationController.visibleViewController as? ExperienceViewController {
                    viewController.experienceController = experienceController
                }
            }
        }
        
        
    }
    
 
}
