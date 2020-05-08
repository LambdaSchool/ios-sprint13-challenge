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

class MapViewController: UIViewController, MapViewDelegate {

    // MARK: - Properites

    var experienceController = ExperienceController()

    private let locManager = CLLocationManager()

    var detailView = MapDetailView()

    // MARK: - Actions


    // MARK: - Outlets

    @IBOutlet var mapView: MKMapView!

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        startLocationManager()

        mapView.delegate = self

        // MKMarkerAnnotationView like a table view cell
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "ExpView")
    }

    override func viewDidAppear(_ animated: Bool) {
        print("🥳 viewDidAppear")
        refreshAnnotations()
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

        var lat = locManager.location?.coordinate.latitude ?? 0.0
        var long = locManager.location?.coordinate.longitude ?? 0.0

        // HACK: Randomly spread the pins around. Privacy feature?
        lat = lat + Double.random(in: -0.005...0.005)
        long = long + Double.random(in: -0.005...0.005)

        return (latitude: lat, longitude: long)
    }

    func invokeViewExperience(_ exp: Experience) {
        performSegue(withIdentifier: "AddSegue", sender: nil)
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

    private func addAnnotations() {
        mapView.addAnnotations(experienceController.experiences)

        // Center the map based on the most recently added experience
        guard let post = self.experienceController.experiences.last else { return }

        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: post.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }

    private func refreshAnnotations() {
        print("Total posts: \(experienceController.experiences.count)")

        mapView.removeAnnotations(mapView.annotations)

        DispatchQueue.main.async {
            self.addAnnotations()
        }
    }
}

protocol MapViewDelegate {

    func invokeViewExperience(_ exp: Experience)
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let experience = annotation as? Experience else {
            fatalError("Only experiences are supported")
        }

        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "ExpView", for: annotation) as? MKMarkerAnnotationView else {
            fatalError("Missing a registered view")
        }

        annotationView.glyphImage = nil // default glyph image of a pin is used
        annotationView.canShowCallout = true
        detailView = MapDetailView()
        detailView.experience = experience
        detailView.delegate = self
        annotationView.detailCalloutAccessoryView = detailView

        return annotationView
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("mapView pin tap")
    }

    func detailView(_ mapView: UIView, didSelect view: UIView) {
        print("detailView pin tap")
    }

}
