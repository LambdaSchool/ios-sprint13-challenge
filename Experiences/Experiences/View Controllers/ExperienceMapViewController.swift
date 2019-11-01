//
//  ExperienceMapViewController.swift
//  Experiences
//
//  Created by Jake Connerly on 11/1/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import UIKit
import MapKit

class ExperienceMapViewController: UIViewController {

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
        
        mapView.removeAnnotations(mapView.annotations)
        
        let annotations = experienceController.experiences.compactMap({ ExperienceAnnotation(experience: $0) })
        
        mapView.addAnnotations(annotations)
    }

    
    // MARK: - Navigation

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let newExperienceVC = segue.destination as? NewExperienceViewController else { return }
        newExperienceVC.experienceController = experienceController
    }
    
    @IBAction func addExperienceButtonTapped(_ sender: UIButton) {
    }
    
}
