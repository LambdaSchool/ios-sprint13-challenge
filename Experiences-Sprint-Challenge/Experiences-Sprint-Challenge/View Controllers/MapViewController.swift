//
//  MapViewController.swift
//  Experiences-Sprint-Challenge
//
//  Created by Matthew Martindale on 7/19/20.
//  Copyright © 2020 Matthew Martindale. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Properties
    private let locationManager = CLLocationManager()
    private var userTrackingButton: MKUserTrackingButton!
    var latitude: Double?
    var longitude: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        setupUserTracking()
    }
    
    private func setupUserTracking() {
        userTrackingButton = MKUserTrackingButton(mapView: mapView)
        userTrackingButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userTrackingButton)
        
        NSLayoutConstraint.activate([
            userTrackingButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -30),
            mapView.bottomAnchor.constraint(equalTo: userTrackingButton.bottomAnchor, constant: 30)
        ])
    }

    @IBAction func addExperienceButtonTapped(_ sender: UIBarButtonItem) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddExperienceSegue" {
            let addExperienceVC = segue.destination as! AddExperienceViewController
            guard let location = locationManager.location?.coordinate else { return }
            latitude = location.latitude
            longitude = location.longitude
            addExperienceVC.latitude = latitude
            addExperienceVC.longitude = longitude
            addExperienceVC.mapView = mapView
        }
    }
    
}
