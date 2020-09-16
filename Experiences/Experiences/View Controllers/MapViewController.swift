//
//  ViewController.swift
//  Experiences
//
//  Created by Farhan on 11/9/18.
//  Copyright © 2018 Farhan. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    let experienceController = ExperienceController()

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "ExperienceAnnotationView")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         self.mapView.addAnnotations(experienceController.experiences)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewExperience" {
            let destVC = segue.destination as? AddExperienceViewController
            
            destVC?.experienceController = experienceController
            
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let experience = annotation as? Experience else {return nil}
        
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "ExperienceAnnotationView", for: experience) as! MKMarkerAnnotationView

        annotationView.glyphTintColor = .white
        annotationView.glyphImage = UIImage(named: "ExperienceIcon")
        
        return annotationView
    }


}

