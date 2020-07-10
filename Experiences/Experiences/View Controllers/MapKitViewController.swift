//
//  MapKitViewController.swift
//  Experiences
//
//  Created by Vincent Hoang on 7/10/20.
//  Copyright © 2020 Vincent Hoang. All rights reserved.
//

import UIKit
import MapKit

class MapKitViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet var mapKitView: MKMapView!
    
    var experience: Experience?

    override func viewDidLoad() {
        super.viewDidLoad()

        mapKitView.delegate = self
        mapKitView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "Annotation")
        
        if let experience = experience {
            mapKitView.addAnnotation(experience)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let experience = experience else {
            NSLog("Experience found to be null")
            return nil
        }
        
        guard let annotation = mapKitView.dequeueReusableAnnotationView(withIdentifier: "Annotation", for: experience) as? MKMarkerAnnotationView else {
            NSLog("Unable to generate annotation")
            return nil
        }
        
        return annotation
    }

}
