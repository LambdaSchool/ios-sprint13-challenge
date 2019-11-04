//
//  ExpMapViewController.swift
//  Experiences
//
//  Created by Ciara Beitel on 11/1/19.
//  Copyright © 2019 Ciara Beitel. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ExpMapViewController: UIViewController, MKMapViewDelegate {
    
    let experienceController = ExperienceController()
    let locationManager = CLLocationManager()
    let annotationReuseIdentifier = "ExpAnnotation"
    var currentLocation: CLLocationCoordinate2D?
    
    @IBOutlet weak var experiencesMapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        experiencesMapView.delegate = self
        experiencesMapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: annotationReuseIdentifier)
        Location.shared.getCurrentLocation { (coordinate) in
                self.currentLocation = coordinate
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchAnnotations()
    }
    
    func fetchAnnotations() {
        let annotations = experiencesMapView.annotations.compactMap({ $0 as? ExperienceAnnotation })
        experiencesMapView.addAnnotations(annotations as [MKAnnotation])
    }
        
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationReuseIdentifier, for: annotation) as? MKMarkerAnnotationView else { return nil }
        annotationView.titleVisibility = .adaptive
        annotationView.subtitleVisibility = .adaptive
        return annotationView
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowNewExpSegue" {
            let destinationVC = segue.destination as? UINavigationController
            
            let nextVC = destinationVC?.viewControllers[0] as? ExperienceViewController
            nextVC?.experienceController = experienceController
        }
    }
}
