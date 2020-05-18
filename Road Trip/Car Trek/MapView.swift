//
//  MapView.swift
//  Road Trip
//
//  Created by Christy Hicks on 5/17/20.
//  Copyright © 2020 Knight Night. All rights reserved.
//

import UIKit
import MapKit

class MapView: MKMapView {
    // MARK: - Properties
    var userTrackingButton = MKUserTrackingButton()
    
    func updateMap() {
        userTrackingButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(userTrackingButton)

            NSLayoutConstraint.activate([
                userTrackingButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
                self.bottomAnchor.constraint(equalTo: userTrackingButton.bottomAnchor, constant: 20)

            ])

            // self.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: .annotationReuseIdentifier)

        }


//    extension MapView: MKMapViewDelegate {
//        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
//            fetchQuakes()
//        }
//
//        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//            guard let quake = annotation as? Quake else { return nil }
//
//            guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: .annotationReuseIdentifier, for: quake) as? MKAnnotationView else {
//                preconditionFailure("Missing the registered map annotation view")
//            }
//
//            annotationView.glyphImage = #imageLiteral(resourceName: "QuakeIcon")
//
//            if quake.magnitude >= 7 {
//                annotationView.markerTintColor = .systemPurple
//            } else if quake.magnitude >= 5 {
//                annotationView.markerTintColor = .systemRed
//            } else if quake.magnitude >= 3 {
//                 annotationView.markerTintColor = .systemOrange
//            } else {
//                annotationView.markerTintColor = .systemYellow
//            }
//
//            annotationView.canShowCallout = true
//
//            let detailView = QuakeDetailView()
//            detailView.quake = quake
//            annotationView.detailCalloutAccessoryView = detailView
//
//
//            return annotationView
//        }
//    }

}
