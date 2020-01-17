//
//  MapViewController.swift
//  Unit4-SprintChallenge1
//
//  Created by Lambda_School_Loaner_204 on 1/16/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    var entryController: EntryController?
    @IBOutlet var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "EntryView")
        // Do any additional setup after loading the view.
    }

    private func fetchEntries() {
        guard let entries = entryController?.entries else { return }

        DispatchQueue.main.async {
            self.mapView.addAnnotations(entries)

            guard let entry = entries.first else { return }

            let span = MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2)
            let region = MKCoordinateRegion(center: entry.coordinate, span: span)
            self.mapView.setRegion(region, animated: true)
        }
    }
}

extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        guard let _ = annotation as? Entry else {
            fatalError("Only Entries are supported right now")
        }

        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "EntryView") as? MKMarkerAnnotationView else {
            fatalError("Missing registered map annotation view")
        }

        return annotationView
    }
}
