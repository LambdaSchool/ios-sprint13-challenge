//
//  ExperienceMapViewController.swift
//  Experiences
//
//  Created by scott harris on 4/10/20.
//  Copyright © 2020 scott harris. All rights reserved.
//

import UIKit
import MapKit

class ExperienceMapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    let experienceController = ExperienceController()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let experiences = experienceController.experiences
//        mapView.delegate = self
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "ExpView")
        
        DispatchQueue.main.async {
            self.mapView.addAnnotations(experiences)
            
            guard let experience = experiences.first else { return }
            let coordinateSpan = MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2)
            let region = MKCoordinateRegion(center: experience.coordinate, span: coordinateSpan)
            self.mapView.setRegion(region, animated: true)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddNewExperienceSegue" {
            if let destVC = segue.destination as? UINavigationController {
                if let rootVC = destVC.viewControllers.first as? CreateExperienceDetailViewController {
                    rootVC.experienceController = experienceController
                }
            }
        }
    }
    
}
