//
//  MapViewController.swift
//  Experiences
//
//  Created by Sean Hendrix on 1/18/19.
//  Copyright © 2019 Sean Hendrix. All rights reserved.
//


import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManagerHelper.requestLocationAuthorization()
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
    
    @IBAction func presentExperiences(_ sender: Any) {
        self.performSegue(withIdentifier: "NewExperience", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewExperience" {
            if let nav = segue.destination as? UINavigationController {
                if let vc = nav.visibleViewController as? ExperiencesHomeViewController {
                    vc.experienceController = experienceController
                }
            }
        }
        
        
    }
    
    let locationManagerHelper = LocationManagerHelper()
    let experienceController = ExperienceController()
    @IBOutlet weak var mapView: MKMapView!
    
}
