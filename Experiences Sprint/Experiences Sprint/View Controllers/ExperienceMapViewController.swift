//
//  ExperienceMapViewController.swift
//  Experiences Sprint
//
//  Created by Harmony Radley on 7/10/20.
//  Copyright © 2020 Harmony Radley. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

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
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "MapView")
        self.locationManager.requestAlwaysAuthorization()
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(true)
           addAnnotation()
       }
    
// MARK: - Methods

    func addAnnotation() {
        mapView.addAnnotations(experienceController.experiences)
        guard let pin = self.experienceController.experiences.last else { return }
        let span = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
        let region = MKCoordinateRegion(center: pin.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewExperienceSegue" {
            guard let experienceDetailVC = segue.destination as? ExperienceDetailViewController else { return }
            experienceDetailVC.experienceController = experienceController
            experienceDetailVC.coordinate = coordinate
        }
    }
}

// MARK: - Extension

extension ExperienceMapViewController: MKMapViewDelegate, CLLocationManagerDelegate {

   func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let experience = annotation as? Experience else { return nil }
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "MapView", for: experience) as! MKMarkerAnnotationView
        annotationView.glyphText = experience.title
        annotationView.glyphTintColor = .systemPink
        annotationView.titleVisibility = .visible
        return annotationView
    }

      func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
          let locValue:CLLocationCoordinate2D = manager.location!.coordinate
          mapView.mapType = MKMapType.standard
          let span = MKCoordinateSpan(latitudeDelta: 0.25, longitudeDelta: 0.25)
          let region = MKCoordinateRegion(center: locValue, span: span)
          mapView.setRegion(region, animated: true)
          let annotation = MKPointAnnotation()
          annotation.coordinate = locValue
          coordinate = annotation.coordinate
      }
}


