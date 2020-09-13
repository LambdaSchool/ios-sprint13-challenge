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
    var experiences: [Experience] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureMapView()
        mapView.delegate = self

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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print(experiences)
        mapView.addAnnotations(experiences)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "NewExperience":
            if let navigationVC = segue.destination as? UINavigationController {
                let newExperienceVC = navigationVC.topViewController as! NewExperienceViewController
                newExperienceVC.experience = experiences
                newExperienceVC.experienceDelegate = self
            }
        default:
            break
        }
    }
}

extension ExperiencesViewController: MKMapViewDelegate {
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {

    }

    private func configureMapView() {
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: .annotationReuseIdentifier)
        mapView.addAnnotations(experiences)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        guard let experience = annotation as? Experience else { return nil }
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: .annotationReuseIdentifier, for: experience) as! MKMarkerAnnotationView

        annotationView.glyphImage = #imageLiteral(resourceName: "icons8-campsite")

        annotationView.canShowCallout = true
        annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        return annotationView
    }
}

extension ExperiencesViewController: ExperienceDelegate {
    func getExperience(experience: Experience) {
        experiences.append(experience)
    }
}
