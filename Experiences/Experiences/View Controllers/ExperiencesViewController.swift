//
//  ExperiencesViewController.swift
//  Experiences
//
//  Created by Vuk Radosavljevic on 10/19/18.
//  Copyright © 2018 Vuk. All rights reserved.
//

import UIKit
import MapKit


class ExperiencesViewController: UIViewController, MKMapViewDelegate {

    // MARK: - Properties
    @IBOutlet weak var mapView: MKMapView!
    var experienceController = ExperienceController.shared
    private let locationManager = CLLocationManager()
    var experiences = [Experience]() {
        didSet {
            DispatchQueue.main.async {
                self.mapView.addAnnotations(self.experiences)
            }
        }
    }

    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "ExperienceAnnotationView")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        experiences = experienceController.experiences
        
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let experience = annotation as? Experience else {return nil}
        
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "ExperienceAnnotationView", for: experience) as! MKMarkerAnnotationView
        annotationView.markerTintColor = .gray
        annotationView.glyphText = experience.titleOfExperience
        annotationView.glyphTintColor = .black
        
        return annotationView
    }
    
    


}
