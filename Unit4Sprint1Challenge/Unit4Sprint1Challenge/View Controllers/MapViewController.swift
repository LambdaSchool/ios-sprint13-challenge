//
//  MapViewController.swift
//  LambdaTimeline
//
//  Created by Jon Bash on 2020-01-16.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    var experienceController: ExperienceController!
    var locationHelper = LocationHelper()

    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let navController = self.navigationController as? MainNavigationController {
            self.experienceController = navController.experienceController
        }
        mapView.delegate = self
        mapView.register(
            MKMarkerAnnotationView.self,
            forAnnotationViewWithReuseIdentifier: "PostAnnotationView")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpTags()
    }

    func setUpTags() {
        // TODO: make more efficient
        mapView.removeAnnotations(experienceController.annotations)
        mapView.addAnnotations(experienceController.annotations)

        guard let lastAnnotation = experienceController.annotations.last
            else { return }
        mapView.setRegion(
            MKCoordinateRegion(
                center: lastAnnotation.coordinate,
                span: MKCoordinateSpan(
                    latitudeDelta: 2,
                    longitudeDelta: 2)),
            animated: true)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let expVC = segue.destination as? AddEditExperienceViewController {
            expVC.experienceController = self.experienceController
            expVC.locationHelper = self.locationHelper
            if segue.identifier == "EditPostSegue",
                let experience = sender as? Experience {
                expVC.experience = experience
            }
        }
    }
}

// MARK: - Delegates

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard
            let experienceAnnotation = annotation as? Experience.MapAnnotation,
            let annotationView = mapView
                .dequeueReusableAnnotationView(withIdentifier: "PostAnnotationView")
                as? MKMarkerAnnotationView
            else { return nil }

        annotationView.canShowCallout = true

        let detailView = ExperienceAnnotationView()
        detailView.experienceAnnotation = experienceAnnotation
        detailView.delegate = self

        annotationView.detailCalloutAccessoryView = detailView

        return annotationView
    }
}

extension MapViewController: ExperienceAnnotationViewDelegate {
    func experienceWasSelected(_ experience: Experience?) {
        performSegue(withIdentifier: "EditPostSegue", sender: experience)
    }
}
