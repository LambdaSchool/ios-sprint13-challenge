//
//  MapViewController.swift
//  Experiences
//
//  Created by denis cedeno on 5/15/20.
//  Copyright © 2020 DenCedeno Co. All rights reserved.
//


import UIKit
import MapKit
import CoreData

extension String {
    static let annotationReuseIdentifier = "ExperienceAnnotationView"
}

class MapViewController: UIViewController {
    
    var experiences: [Experience] = []

        @IBOutlet var mapView: MKMapView!
        
        private var userTrackingButton: MKUserTrackingButton!
        var locationManager: CLLocationManager?

        override func viewDidLoad() {
            super.viewDidLoad()
            locationManager?.requestWhenInUseAuthorization()
            
            userTrackingButton = MKUserTrackingButton(mapView: mapView)
            userTrackingButton.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(userTrackingButton)
            
            NSLayoutConstraint.activate([
                userTrackingButton.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 20),
                mapView.bottomAnchor.constraint(equalTo: userTrackingButton.bottomAnchor, constant: 20)
            ])
            
            mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: .annotationReuseIdentifier)
            
            fetchExperience(experiences)
        }

        func fetchExperience(_ expereinces: [Experience]) {
          for experience in experiences {
            let annotations = MKPointAnnotation()
            annotations.title = experience.title
            annotations.subtitle = "\(String(describing: experience.date))"
            annotations.coordinate = CLLocationCoordinate2D(latitude:
              experience.latitude, longitude: experience.longitude)
            mapView.addAnnotation(annotations)
          }
        }
    }
