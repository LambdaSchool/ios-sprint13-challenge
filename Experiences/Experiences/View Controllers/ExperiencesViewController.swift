//
//  ExperiencesViewController.swift
//  Experiences
//
//  Created by Elizabeth Thomas on 9/11/20.
//  Copyright © 2020 Libby Thomas. All rights reserved.
//

import UIKit
import MapKit

class ExperiencesViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var mapView: MKMapView!

    // MARK: - Properties
    var experienceTitle: String?
    var currentLocation: CLLocationCoordinate2D?
    var annotations: [MKAnnotation] = []

    let locationManager = CLLocationManager.shared
    let experienceController = ExperienceController()


    override func viewDidLoad() {
        super.viewDidLoad()

        setUpLocation()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        setUpAnnotations()
    }

    private func setUpLocation() {
        locationManager.delegate = self

        let status = CLLocationManager.authorizationStatus()

        switch status {
        case .authorizedAlways:
            beginLocationUpdates(locationManager)
        case .authorizedWhenInUse:
            beginLocationUpdates(locationManager)
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            NSLog("Please allow location services for functionality of this app.")
        }
    }

    private func setUpAnnotations() {
        let experiences = experienceController.experiences

        for experience in experiences {
            let annotation = MKPointAnnotation()
            annotation.title = experience.title
            annotation.coordinate = experience.location
            annotations.append(annotation)
        }
        mapView.addAnnotations(annotations)
    }

    private func beginLocationUpdates(_: CLLocationManager) {
        mapView.showsUserLocation = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }

    private func moveToLastLocation(with coordinate: CLLocationCoordinate2D) {
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddExperienceSegue" {
            let destination = segue.destination as? AddExperienceViewController
            destination?.experienceController = experienceController
        }
    }

}

extension String {
    static let annotationReuseIdentifier = "ExperienceAnnotationView"
}

extension ExperiencesViewController: CLLocationManagerDelegate, MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: .annotationReuseIdentifier)
        annotationView?.canShowCallout = true

        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: .annotationReuseIdentifier)
        }
        return annotationView
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            beginLocationUpdates(manager)
        }
        else {
            NSLog("Invalid status code for Location Manager.")
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.first else { return }

        if currentLocation == nil {
            moveToLastLocation(with: lastLocation.coordinate)
            setUpAnnotations()
        }
        currentLocation = lastLocation.coordinate
        setUpAnnotations()
    }
}

extension CLLocationManager {
    static let shared = CLLocationManager()
}
