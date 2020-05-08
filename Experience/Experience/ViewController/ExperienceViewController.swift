//
//  ExperienceViewController.swift
//  Experience
//
//  Created by Lydia Zhang on 5/8/20.
//  Copyright © 2020 Lydia Zhang. All rights reserved.
//

import UIKit
import MapKit

class ExperienceViewController: UIViewController, CLLocationManagerDelegate {
    
    let experiences = Experiences()
    var currentLocation: CLLocation!
    var locationManager = CLLocationManager()
    let newPin = MKPointAnnotation()
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "ExperienceView")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let experience = experiences.experiences.first else { return }

        mapView.addAnnotations(experiences.experiences)

        let span = MKCoordinateSpan(latitudeDelta: 2.5, longitudeDelta: 2.5)

        let region = MKCoordinateRegion(center: experience.coordinate, span: span)

        mapView.setRegion(region, animated: true)


    }
    

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddExpSegue" {
            guard let createExpVC = segue.destination as? CreateViewController else {return}
            createExpVC.experiences = experiences
        }
    }
}


extension ExperienceViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "ExperienceView", for: annotation) as? MKMarkerAnnotationView else {
            fatalError("Missing a registered view")
        }

        annotationView.canShowCallout = true

        return annotationView
    }
}
