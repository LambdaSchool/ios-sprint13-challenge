//
//  MapViewController.swift
//  MediaProgrammingSprintChallenge
//
//  Created by Nathanael Youngren on 3/29/19.
//  Copyright © 2019 Nathanael Youngren. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: "MomentAnnotationView")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        momentController.fetchMoments { (moments, error) in
            if let error = error {
                print("Error fetching moments: \(error).")
                return
            }
            
            guard let moments = moments else { return }
            
            self.mapView.addAnnotations(moments)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let moment = annotation as? Moment else { return nil }
        
        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "MomentAnnotationView", for: moment) as? MKMarkerAnnotationView else { return nil }
        
        annotationView.glyphTintColor = .white
        annotationView.markerTintColor = .lightGray
        
        annotationView.canShowCallout = true
        
        let detailView = MomentDetailView(frame: .zero)
        
        detailView.moment = moment
        
        annotationView.detailCalloutAccessoryView = detailView
        
        return annotationView
    }
    
    @IBOutlet weak var mapView: MKMapView!
    
    let momentController = MomentController()
}
