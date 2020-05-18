//
//  MapViewController.swift
//  Experiences
//
//  Created by Joshua Rutkowski on 5/17/20.
//  Copyright © 2020 Josh Rutkowski. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet var mapView: MKMapView!
    
    // MARK: - Properties
    
    let experienceController = ExperienceController()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "ExperienceView")
    }
    

    @IBAction func addExperienceButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "CreateExperienceViewController")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let experience = experienceController.experiences.first else { return }
        
        mapView.addAnnotations(experienceController.experiences)
        
        let span = MKCoordinateSpan(latitudeDelta: 2.5, longitudeDelta: 2.5)
        
        let region = MKCoordinateRegion(center: experience.coordinate, span: span)
        
        mapView.setRegion(region, animated: true)
        
    }

    
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let experience = annotation as? Experience else { fatalError("No coordinates") }
        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "ExperienceView") as? MKMarkerAnnotationView else { fatalError("No view") }
        
        annotationView.canShowCallout = true
        annotationView.annotation = experience
        return annotationView
    }
}

