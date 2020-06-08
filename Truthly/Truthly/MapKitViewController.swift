//
//  MapKitViewController.swift
//  Truthly
//
//  Created by Ezra Black on 6/7/20.
//  Copyright © 2020 Casanova Studios. All rights reserved.
//

import UIKit
import MapKit

class MapKitViewController: UIViewController {
      //MARK: Properties
//        let quakeFetcher = QuakeFetcher()
        // NOTE: You need to import MapKit to link to MKMapView
        @IBOutlet var mapView: MKMapView!
        override func viewDidLoad() {
            super.viewDidLoad()
            mapView.delegate = self
            mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "QuakeView")
        }
    }
    //this is to customize the pins on the map
    extension MapKitViewController: MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard let post = annotation as? Post else {
                fatalError("Only Quakes are supported")
            }
            guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "QuakeView", for: annotation) as? MKMarkerAnnotationView else {
                fatalError("Missing a registered view")
            }
            annotationView.glyphImage = UIImage(named: "QuakeIcon")
            //these four lines give you the pins detail view!!
            annotationView.canShowCallout = true
            let detailView = MapAnnotationDetailView()
            detailView.post = post
            annotationView.detailCalloutAccessoryView = detailView
            
            return annotationView
        }
}
