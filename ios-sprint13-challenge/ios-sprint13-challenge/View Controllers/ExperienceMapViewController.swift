//
//  ExperienceMapViewController.swift
//  ios-sprint13-challenge
//
//  Created by Conner on 10/19/18.
//  Copyright © 2018 Conner. All rights reserved.
//

import UIKit
import MapKit

class ExperienceMapViewController: UIViewController {
    @IBOutlet var mapView: MKMapView!
    
    private let locationManager = CLLocationManager()
    private var experiences = [Experience]() {
        didSet {
            DispatchQueue.main.async {
                self.mapView.addAnnotations(self.experiences)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "ExperienceAnnotationView")
    }
}

extension ExperienceMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let experience = annotation as? Experience else { return nil }
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "ExperienceAnnotationView", for: experience) as! MKMarkerAnnotationView
        
        return annotationView
    }
}
