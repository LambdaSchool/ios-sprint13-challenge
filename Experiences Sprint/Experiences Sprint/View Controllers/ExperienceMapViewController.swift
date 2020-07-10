//
//  ExperienceMapViewController.swift
//  Experiences Sprint
//
//  Created by Harmony Radley on 7/10/20.
//  Copyright © 2020 Harmony Radley. All rights reserved.
//

import UIKit
import MapKit

class ExperienceMapViewController: UIViewController {

    // MARK: - Properties

    let experienceController = ExperienceController()
    let locationManager = CLLocationManager()
    var coordinate: CLLocationCoordinate2D?

    // MARK: - Outlets

    @IBOutlet var mapView: MKMapView!
    @IBOutlet var newExperienceButton: UIBarButtonItem!

    // MARK: - View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
    }
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewExperienceSegue" {
            guard let experienceDetailVC = segue.destination as? ExperienceDetailViewController else { return }
            experienceDetailVC.experienceController = experienceController
            experienceDetailVC.coordinate = coordinate
        }
    }
}

extension ExperienceMapViewController: MKMapViewDelegate, CLLocationManagerDelegate {

    guard let experience = annotation as? Experience else { return nil }

    let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "MapView", for: experience) as! MKMarkerAnnotationView
    annotationView.glyphText = experience.experienceTitle
    annotationView.glyphTintColor = .systemPink
    annotationView.titleVisibility = .visible
    return annotationView
}


