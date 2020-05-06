//
//  ExperienceMapViewController.swift
//  Experiences
//
//  Created by Jason Modisett on 1/18/19.
//  Copyright © 2019 Jason Modisett. All rights reserved.
//

import UIKit
import MapKit

class ExperienceMapViewController: UIViewController, MKMapViewDelegate {
    
    // MARK:- Types, properties, & IBOutlets
    
    let locationManager = CLLocationManager()
    let experienceController = ExperienceController()
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    // MARK:- View lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        
        mapView.delegate = self
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "ExperienceAnnotationView")
    }
    
    
    // MARK:- MapViewDelegate methods
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let experience = annotation as? Experience else { return nil }
        
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "ExperienceAnnotationView", for: experience) as! MKMarkerAnnotationView
        
        return annotationView
    }
    
    
    // MARK:- Navigation
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let navVC = segue.destination as? NavigationController,
              let vc = navVC.viewControllers.first as? NewExperienceViewController else { return }
        
        vc.experienceController = experienceController
        vc.coordinate = mapView.userLocation.coordinate
        vc.mapView = mapView
    }

}

