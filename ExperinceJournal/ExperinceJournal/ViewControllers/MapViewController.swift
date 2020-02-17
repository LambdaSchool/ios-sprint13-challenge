//
//  MapViewController.swift
//  ExperinceJournal
//
//  Created by Lambda_School_Loaner_218 on 2/16/20.
//  Copyright © 2020 Lambda_School_Loaner_218. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    var entryController: EntryController?
    
    
    
    @IBOutlet var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self as? MKMapViewDelegate
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "EntryView")
        fetchEntries()
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
    
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
            
        case .notDetermined:
            break
        case .restricted:
            break
        case .denied:
            break
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
        @unknown default:
            break
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


