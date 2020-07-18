//
//  MapViewController.swift
//  Experiences
//
//  Created by Chad Parker on 7/17/20.
//  Copyright © 2020 Chad Parker. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    // MARK: - Properties

    private var experiences = [Experience]() {
        didSet {
            let oldXPs = Set(oldValue)
            let newXPs = Set(experiences)

            let addedXPs = Array(newXPs.subtracting(oldXPs))
            let removedXPs = Array(oldXPs.subtracting(newXPs))

            mapView.removeAnnotations(removedXPs)
            mapView.addAnnotations(addedXPs)
        }
    }

    @IBOutlet private var mapView: MKMapView!

    private var currentLocation: CLLocationCoordinate2D?
    private let locationManager = CLLocationManager()


    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewExperienceSegue" {
            guard let newExperienceNav = segue.destination as? UINavigationController,
                let newExperienceVC = newExperienceNav.topViewController as? NewExperienceViewController else { fatalError("Incorrect VC")}
            guard let currentLocation = currentLocation else { fatalError("No current location") }
            newExperienceVC.currentLocation = currentLocation
            newExperienceVC.delegate = self
        }
    }
}


// MARK: - Location Delegate

extension MapViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        let currentLocation = location.coordinate
        let coordinateRegion = MKCoordinateRegion(center: currentLocation, latitudinalMeters: 8000, longitudinalMeters: 8000)
        self.currentLocation = currentLocation
        mapView.setRegion(coordinateRegion, animated: true)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
       print(error.localizedDescription)
    }
}


extension MapViewController: NewExperienceDelegate {

    func newExperienceSaved(_ experience: Experience) {
        experiences.append(experience)
    }
}
