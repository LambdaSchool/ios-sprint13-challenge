//
//  ExperiencesViewController.swift
//  Experiences
//
//  Created by Tobi Kuyoro on 08/05/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import UIKit
import MapKit

class ExperiencesViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var mapView: MKMapView!

    // MARK: - Properties

    let experienceController = ExperienceController()
    let locationManager = CLLocationManager()

    var experience: Experience?
    var currentCoordinate: CLLocationCoordinate2D?
    var annotations: [MKAnnotation] = []

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLocation()
    }

    // MARK: - Actions

    private func configureLocation() {
        locationManager.delegate = self

        let status = CLLocationManager.authorizationStatus()

        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else if status == .authorizedAlways || status == .authorizedWhenInUse {
            beginLocationUpdates(using: locationManager)
        }
    }

    private func beginLocationUpdates(using locationManager: CLLocationManager) {
        mapView.showsUserLocation = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
}

extension ExperiencesViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            beginLocationUpdates(using: locationManager)
        }
    }
}
