//
//  MapViewController.swift
//  Experiences
//
//  Created by Mark Gerrior on 5/8/20.
//  Copyright © 2020 Mark Gerrior. All rights reserved.
//

import UIKit
// NOTE: Don't forget Project > Target > General > Frameworks > add MapKit
import MapKit

class MapViewController: UIViewController {

    // MARK: - Properites

    var experienceController = ExperienceController()

    private let locManager = CLLocationManager()

    // MARK: - Actions


    // MARK: - Outlets

    @IBOutlet var mapView: MKMapView!

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        startLocationManager()

        mapView.delegate = self

        // MKMarkerAnnotationView like a table view cell
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "PostView")

        print("Total posts: \(experienceController.experiences.count)")

        DispatchQueue.main.async {
            self.mapView.addAnnotations(self.experienceController.experiences)

            // Center the map based on the first element
            guard let post = self.experienceController.experiences.first else { return }

            let span = MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2)
            let region = MKCoordinateRegion(center: post.coordinate, span: span)
            self.mapView.setRegion(region, animated: true)
        }
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddSegue" {
            guard let vc = segue.destination as? AddViewController else { return }
            vc.experienceController = experienceController
            vc.delegate = self
        }
    }

    // MARK: - Public
    func whereAmI() -> (latitude: Double, longitude: Double){

        let lat = locManager.location?.coordinate.latitude ?? 0.0
        let long = locManager.location?.coordinate.longitude ?? 0.0

        return (latitude: lat, longitude: long)
    }

    // MARK: - Private

    private func startLocationManager() {
        // Ask for Authorisation from the User.
        locManager.requestAlwaysAuthorization()

        // For use in foreground
        locManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locManager.startUpdatingLocation()
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let experience = annotation as? Experience else {
            fatalError("Only experiences are supported")
        }

        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "PostView", for: annotation) as? MKMarkerAnnotationView else {
            fatalError("Missing a registered view")
        }

        annotationView.glyphImage = nil // default glyph image of a pin is used
        annotationView.canShowCallout = true
        let detailView = MapDetailView()
        detailView.experience = experience
        annotationView.detailCalloutAccessoryView = detailView

        return annotationView
    }
}
