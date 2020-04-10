//
//  MapViewController + MKMapViewDelegate.swift
//  UX
//
//  Created by Nick Nguyen on 4/10/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import MapKit
import UIKit

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let identifier = "Post"
              
              let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
              
              if annotation is MKUserLocation {    return nil    }
               
        annotationView?.glyphImage = UIImage(systemName: "star")
        annotationView?.glyphTintColor = .yellow
        annotationView?.accessibilityActivate()
        annotationView?.canShowCallout = true
        let button = UIButton(type: .detailDisclosure)

          annotationView?.rightCalloutAccessoryView = button
          return annotationView
      }
      func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            // Open Apple map
            let coordinate = CLLocationCoordinate2DMake(mapView.centerCoordinate.latitude,
                                                        mapView.centerCoordinate.longitude)
            
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate,
                                                           addressDictionary:nil))
            
            if let annotation = view.annotation, let name = annotation.title {
                mapItem.name = "\(name ?? "...")"
            }
            
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])

         }
}
