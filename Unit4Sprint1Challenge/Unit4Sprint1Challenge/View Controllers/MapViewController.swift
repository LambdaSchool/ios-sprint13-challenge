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
        setUpTags()
    }

    func setUpTags() {
        let annotations = experienceController.models.compactMap { $0.mapAnnotation }
        mapView.addAnnotations(annotations)

        guard let firstAnnotation = annotations.first else { return }
        mapView.setRegion(
            MKCoordinateRegion(
                center: firstAnnotation.coordinate,
                span: MKCoordinateSpan(
                    latitudeDelta: 2,
                    longitudeDelta: 2)),
            animated: true)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewPostSegue",
            let newPostVC = segue.destination as? AddEditExperienceViewController {
            newPostVC.experienceController = self.experienceController
        }
    }
}

// MARK: - MapView Delegate

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
        annotationView.detailCalloutAccessoryView = detailView

        return annotationView
    }
}
