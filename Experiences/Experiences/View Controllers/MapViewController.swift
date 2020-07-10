//
//  MapViewController.swift
//  Experiences
//
//  Created by Enzo Jimenez-Soto on 7/10/20.
//  Copyright © 2020 Enzo Jimenez-Soto. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MapViewDelegate {
    
    var experienceController = ExperienceController()

       private let locManager = CLLocationManager()

       var detailView = MapLocationView()

       // MARK: - Outlets

       @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startLocationManager()

              mapView.delegate = self

              // MKMarkerAnnotationView is like a table view cell
              mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "ExpView")
    }
    
     override func viewDidAppear(_ animated: Bool) {
            refreshAnnotations()
        }

        // MARK: - Navigation
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "AddSegue" {
                guard let vc = segue.destination as? ExperiencesViewController else { return }
                vc.experienceController = experienceController
                vc.delegate = self
                if let exp = sender as? Experience {
                    vc.experience  = exp
                }
            }
        }

        // MARK: - Public
        func myLocation() -> (latitude: Double, longitude: Double){

            var lat = locManager.location?.coordinate.latitude ?? 0.0
            var long = locManager.location?.coordinate.longitude ?? 0.0

            lat = lat + Double.random(in: -0.005...0.005) // FUTURE: Privacy feature?
            long = long + Double.random(in: -0.005...0.005)

            return (latitude: lat, longitude: long)
        }

        func invokeViewExperience(_ exp: Experience) {
            performSegue(withIdentifier: "AddSegue", sender: exp)
        }

        // MARK: - Private

        private func startLocationManager() {
            // Ask for Authorisation from the User.
            locManager.requestAlwaysAuthorization()

            // For use in foreground
            locManager.requestWhenInUseAuthorization()

            if CLLocationManager.locationServicesEnabled() {
                locManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locManager.startUpdatingLocation()
            }
        }

        private func addAnnotations() {
            mapView.addAnnotations(experienceController.experiences)

            // Center the map based on the most recently added experience
            guard let post = self.experienceController.experiences.last else { return }

            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: post.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }

        private func refreshAnnotations() {
            print("Total posts: \(experienceController.experiences.count)")

            mapView.removeAnnotations(mapView.annotations)

            DispatchQueue.main.async {
                self.addAnnotations()
            }
        }
    }

    protocol MapViewDelegate {

        func invokeViewExperience(_ exp: Experience)
    }

    extension MapViewController: MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard let experience = annotation as? Experience else {
                fatalError("Only experiences are supported")
            }

            guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "ExpView", for: annotation) as? MKMarkerAnnotationView else {
                fatalError("Missing a registered view")
            }

            annotationView.glyphImage = nil // default glyph image of a pin is used
            annotationView.canShowCallout = true
            detailView = MapLocationView()
            detailView.delegate = self
            detailView.experience = experience
            annotationView.detailCalloutAccessoryView = detailView

            return annotationView
        }

        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            print("mapView pin tap")
        }

        func detailView(_ mapView: UIView, didSelect view: UIView) {
            print("detailView pin tap")
        }



}
