//
//  MapViewController.swift
//  MyExperiences
//
//  Created by Diante Lewis-Jolley on 7/12/19.
//  Copyright © 2019 Diante Lewis-Jolley. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate {


    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var location: CLLocationCoordinate2D!
    var expController = ExperienceController()
    let regionInMeters: Double = 10000

    


    override func viewDidLoad() {
        super.viewDidLoad()

        setupLocationManager()

        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "ExperienceAnnotationView")

        
    }

    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func checkLocationServices() {

        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()

        }
    }

    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            if expController.experiences.count > 0 {
                centerViewOnUserLocation()
            }

        case .denied:
            presentInformationalAlertController(title: "Error", message: "Must enable location in settings")
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            presentInformationalAlertController(title: "Error", message: "You've been Rescricted!")
        case .authorizedAlways:
            mapView.showsUserLocation = true
        @unknown default:
            break
        }
    }



    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            var region = MKCoordinateRegion(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
       // guard let experience = annotation as? Experience else { return nil }

        let experienceView = mapView.dequeueReusableAnnotationView(withIdentifier: "ExperienceAnnotationView", for: annotation) as! MKMarkerAnnotationView

        experienceView.glyphText = expController.newExperience?.title
        experienceView.markerTintColor = .red

        return experienceView


    }


  /*  @IBAction func addExperienceButtonTapped(_ sender: Any) {

        let experience = Experience(title: nil, audio: nil, image: nil, video: nil, coordinate: location)

        expController.experiences.append(experience)
    }
 */

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToExperiencesView" {
            guard let ExpVC = segue.destination as? ExperiencesViewController else { return }

            ExpVC.expController = expController
            expController.currentLocation = locationManager.location?.coordinate
            
        }
    }


}

extension MapViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NSLog("Error using location Delegate: \(error)")
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

    }

}
