//
//  MapViewController.swift
//  Experiences
//
//  Created by Shawn Gee on 5/8/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    // MARK: - Private Properties
    
    let experienceController = ExperienceController()

    // MARK: - IBOutlets
    
    @IBOutlet private weak var mapView: MKMapView! { didSet { setUpMapView() }}
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Private Methods
    
    private func setUpMapView() {
        mapView.delegate = self
        updateExperienceAnnotations()
    }
    
    private func updateExperienceAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(experienceController.experiences)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let experienceVC = segue.destination as? ExperienceViewController {
            experienceVC.experienceController = experienceController
        }
    }
}

extension MapViewController: MKMapViewDelegate {
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        guard let quake = annotation as? Quake else {
//            fatalError("Only quakes are supported")
//        }
//
//        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "QuakeView", for: annotation) as? MKMarkerAnnotationView else {
//            fatalError("Unable to cast annotation view as \(MKMarkerAnnotationView.self)")
//        }
//
//        annotationView.glyphImage = UIImage(named: "QuakeIcon")
//
//        if let magnitude = quake.magnitude {
//            switch magnitude {
//            case 5...:
//                annotationView.markerTintColor = .red
//            case 3..<5:
//                annotationView.markerTintColor = .orange
//            default:
//                annotationView.markerTintColor = .yellow
//            }
//        } else {
//            annotationView.markerTintColor = .white
//        }
//
//        annotationView.canShowCallout = true
//        let detailView = QuakeDetailView()
//        detailView.quake = quake
//        annotationView.detailCalloutAccessoryView = detailView
//
//        return annotationView
//    }
}


