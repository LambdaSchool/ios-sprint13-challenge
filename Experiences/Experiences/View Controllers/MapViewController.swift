//
//  ViewController.swift
//  Experiences
//
//  Created by Jonathan Ferrer on 7/12/19.
//  Copyright © 2019 Jonathan Ferrer. All rights reserved.
//

import UIKit
import ImageIO
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkLocationServices()
        print(experienceController.experiences.count)
        mapView.delegate = self
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "ExperienceAnnotationView")
        DispatchQueue.main.async {
            self.mapView.addAnnotations(self.experienceController.experiences)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddExperience" {
            if let navigationController = segue.destination as? UINavigationController {
                let childViewController = navigationController.topViewController as? AddExperienceViewController
                childViewController?.location = locationManager.location?.coordinate
                childViewController?.experienceController = experienceController
            }
        }
        if segue.identifier == "ShowExperience" {
            if let navigationController = segue.destination as? UINavigationController {
                let childViewController = navigationController.topViewController as? AnnotationViewController
                childViewController?.experience = currentExperience
            }
        }
    }

    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {

        }
    }

    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }

    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            if experienceController.experiences.count > 0 {
                centerViewOnUserLocation()
            }
            break
        case .denied:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:

            break
        case .authorizedAlways:
            break
        @unknown default:
            fatalError()
        }
    }

    let locationManager = CLLocationManager()
    let regionInMeters: Double = 10000
    let experienceController = ExperienceController()
    var currentExperience: Experience?
    @IBOutlet weak var mapView: MKMapView!
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

    }
}

extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "ExperienceAnnotationView", for: annotation) as! MKMarkerAnnotationView

        annotationView.glyphImage = UIImage(named: "Marker")
        annotationView.glyphTintColor = .white
        annotationView.markerTintColor = .black

        return annotationView
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let experience = view.annotation as? Experience else { return }
        currentExperience = experience
        performSegue(withIdentifier: "ShowExperience", sender: nil)

    }
}
