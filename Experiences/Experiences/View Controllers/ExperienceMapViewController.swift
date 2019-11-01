//
//  ExperienceMapViewController.swift
//  Experiences
//
//  Created by Jake Connerly on 11/1/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import UIKit
import MapKit

class ExperienceMapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var addExperienceButton: UIButton!
    let experienceController = ExperienceController()
    
    let annotationReuseIdentifier = "ExperienceAnnotation"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: annotationReuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchAnnotations()
    }
    
    func fetchAnnotations() {
        var annotations: [MKAnnotation] = []
        for experience in experienceController.experiences {
            if let experienceAnnotation = ExperienceAnnotation(experience: experience) {
                annotations.append(experienceAnnotation)
            }
        }
        mapView.addAnnotations(annotations)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        guard let av = mapView.dequeueReusableAnnotationView(withIdentifier: annotationReuseIdentifier, for: annotation) as? MKMarkerAnnotationView else { return nil }
        
        av.titleVisibility = .adaptive
        av.subtitleVisibility = .adaptive
        
        return av
    }

    
    // MARK: - Navigation

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddExperienceSegue" {
            guard let newExperienceVC = segue.destination as? NewExperienceViewController else {
                print("error getting controller ")
                return
                
            }
            newExperienceVC.experienceController = experienceController
        }
    }
    
    @IBAction func addExperienceButtonTapped(_ sender: UIButton) {
    }
    
}
