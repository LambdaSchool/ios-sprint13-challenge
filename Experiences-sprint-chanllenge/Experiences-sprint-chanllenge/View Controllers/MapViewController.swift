//
//  MapViewController.swift
//  Experiences-sprint-chanllenge
//
//  Created by Gi Pyo Kim on 12/6/19.
//  Copyright © 2019 GIPGIP Studio. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    let experienceController = ExperienceController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "ExperienceView")

        fetchExperiences()
        
    }
    
    private func fetchExperiences() {
        let experiences = experienceController.experiences
        DispatchQueue.main.async {
            self.mapView.addAnnotations(experiences)
            
            guard let lastExperience = experiences.last else { return }
            
            // Zoom to latest experience
            let coordinateSpan = MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2)
            let region = MKCoordinateRegion(center: lastExperience.coordinate, span: coordinateSpan)
            self.mapView.setRegion(region, animated: true)
        }
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewExperienceSegue" {
            if let addExperienceVC =  segue.destination as? AddExperienceViewController {
                addExperienceVC.experienceController = experienceController
            }
        }
    }
    
    
    
    @IBAction func createNewExperience(_ sender: Any) {
        performSegue(withIdentifier: "NewExperienceSegue", sender: self)
    }
    
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let experience = annotation as? Experience else {
            fatalError("Experience object not found in map")
        }
        
        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "ExperienceView") as? MKMarkerAnnotationView else {
            fatalError("Missing a registered map annotation view")
        }
        
        // change pin to be the images
        annotationView.glyphImage = UIImage(data: experience.imageData)
        
        // play video recording in detail view
        
        
        return annotationView
    }
}
