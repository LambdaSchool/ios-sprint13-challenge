//
//  MapViewController.swift
//  Experiences
//
//  Created by Bobby Keffury on 1/24/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    //MARK: - Properties
    
    private let locationManager = CLLocationManager()
    private let annotationReuseIdentifier = "ExperienceAnnotation"
    
    // Fix This!!!!!! vvvvvv
    var annotations: [String] = []
    
    //MARK: - Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: - Views

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: annotationReuseIdentifier)
    }
    
    //MARK: - Methods
    
    func fetchAnnotations() {
        //FIX THIS
    }
    //MARK: - Actions
    
    //MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        fetchAnnotations()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let experience = annotation as? ExperienceAnnotation else { return nil }
        
        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationReuseIdentifier, for: experience) as? MKMarkerAnnotationView else {
            fatalError("Missing registered map annotation view.")
        }
        
        return annotationView
    }
}
