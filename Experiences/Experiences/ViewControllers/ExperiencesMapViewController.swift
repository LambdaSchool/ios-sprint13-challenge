//
//  ExperiencesMapViewController.swift
//  Experiences
//
//  Created by Bradley Diroff on 6/7/20.
//  Copyright © 2020 Bradley Diroff. All rights reserved.
//

import UIKit
import MapKit

class ExperiencesMapViewController: UIViewController {
    
    @IBOutlet var mapView: MKMapView!
    
    var experiences: [Experience] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.addAnnotations(experiences)
        
        print(experiences.count)
        
        mapView.delegate = self
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "ExperienceView")
    }
}

extension ExperiencesMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let experience = annotation as? Experience else {
            fatalError("It caught something other than an experience")
        }
        
        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "ExperienceView", for: experience) as? MKMarkerAnnotationView else {
            fatalError("Not registering an annotation")
        }
        
        return annotationView
    }
}
