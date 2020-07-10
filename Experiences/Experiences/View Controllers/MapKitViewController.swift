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
        guard annotation is MKPointAnnotation else { return nil }
        
        var annotationView = mapKitView.dequeueReusableAnnotationView(withIdentifier: "Annotation")
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Annotation")
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        
        return annotationView
    }

}
