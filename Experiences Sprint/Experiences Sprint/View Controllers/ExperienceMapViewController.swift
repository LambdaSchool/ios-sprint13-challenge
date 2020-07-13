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
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        locationManager.requestLocation()
        self.locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        coordinate = locationManager.location?.coordinate
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "MapView")

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        UserLocation()
        mapView.addAnnotations(experienceController.experiences)
        mapView.showAnnotations(experienceController.experiences, animated: true)
    }
    
    // MARK: - Methods

    func UserLocation() {
        if let location = locationManager.location?.coordinate {
            let span = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
            let region = MKCoordinateRegion.init(center: location, span: span)

            mapView.setRegion(region, animated: true)
        }
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
        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "MapView", for: experience) as? MKMarkerAnnotationView else {
            fatalError("Missing a registered map annotation view")
        }
        return annotationView
    }
    

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        coordinate = manager.location?.coordinate
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

        guard status != CLAuthorizationStatus.authorizedAlways || status != CLAuthorizationStatus.authorizedWhenInUse else { return }

        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NSLog("Error: Did fail with error \(error)")
    }
}


