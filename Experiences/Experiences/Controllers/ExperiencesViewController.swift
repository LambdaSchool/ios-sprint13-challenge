//
//  ExperiencesViewController.swift
//  Experiences
//
//  Created by Josh Kocsis on 9/11/20.
//  Copyright © 2020 Josh Kocsis. All rights reserved.
//

import UIKit
import MapKit

class ExperiencesViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addExperienceButton: UIButton!

    private var userTrackingButton: MKUserTrackingButton!
    private let locationManager = CLLocationManager()
    var experience: [Experience] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()

        mapView.showsUserLocation = true

        userTrackingButton = MKUserTrackingButton(mapView: mapView)
        userTrackingButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userTrackingButton)

        NSLayoutConstraint.activate([
            userTrackingButton.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 20),
            mapView.bottomAnchor.constraint(equalTo: userTrackingButton.bottomAnchor, constant: 20)
        ])
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "NewExperience":
            print("")
        default:
            break
        }
    }

    @IBAction func addExperience(_ sender: UIButton) {

    }
}

