//
//  MapViewController.swift
//  Experiences
//
//  Created by Michael Stoffer on 9/28/19.
//  Copyright © 2019 Michael Stoffer. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: - Outlets and Properties
    
    @IBOutlet var mapView: MKMapView!
    
    private let locationManager = CLLocationManager()
    let experienceController = ExperienceController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "ExperienceAnnotationView")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.mapView.addAnnotations(self.experienceController.experiences)
    }

    // MARK: - MKMapViewDelegate Methods

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let experience = annotation as? Experience else { return nil }
        
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "ExperienceAnnotationView", for: experience) as! MKMarkerAnnotationView
        annotationView.glyphTintColor = .red
        annotationView.canShowCallout = true
        
        return annotationView
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToAddExperience" {
            if let nav = segue.destination as? UINavigationController {
                guard let imageAVC = nav.visibleViewController as? ImageAudioViewController else { return }
                imageAVC.experienceController = self.experienceController
            }
        }
    }
}

