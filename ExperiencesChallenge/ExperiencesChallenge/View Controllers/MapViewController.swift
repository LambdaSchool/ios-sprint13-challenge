//
//  MapViewController.swift
//  ExperiencesChallenge
//
//  Created by Ian French on 9/13/20.
//  Copyright © 2020 Ian French. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {


    @IBOutlet weak var mapView: MKMapView!

    var location: CLLocationCoordinate2D?

    var experienceController: ExperienceController?
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: .annotationReuseIdentifier)
        mapView.delegate = self
        fetchExperiences()
    }
    
    func setPinUsingMKPointAnnotation(location: CLLocationCoordinate2D){
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        let coordinateRegion = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 200, longitudinalMeters: 200)
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.addAnnotation(annotation)
    }

    private func fetchExperiences() {
        guard let experiences = experienceController?.experiences else { return }

        DispatchQueue.main.async {
            self.mapView.addAnnotations(experiences)

            guard let entry = experiences.first else { return }

            let span = MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2)
            let region = MKCoordinateRegion(center: entry.coordinate, span: span)
            self.mapView.setRegion(region, animated: true)
        }
    }
}
extension String {
    static let annotationReuseIdentifier = "EntryView"
}

extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        guard let _ = annotation as? Experience else {
            fatalError("Only Experiences are supported")
        }
        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: .annotationReuseIdentifier) as? MKMarkerAnnotationView else {
            fatalError("Missing map annotation view")
        }
        return annotationView
    }
}

