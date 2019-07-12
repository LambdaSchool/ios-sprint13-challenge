//
//  MapViewController.swift
//  MyExperiences
//
//  Created by Diante Lewis-Jolley on 7/12/19.
//  Copyright © 2019 Diante Lewis-Jolley. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate {


    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var location: CLLocationCoordinate2D!
    var expController = ExperienceController.shared

    


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func updateViews() {

        let annotations = mapView.annotations

        mapView.removeAnnotations(annotations)

        if expController.newExperience != nil {

            mapView.addAnnotation(expController.newExperience!)

            let pin = MKPointAnnotation()
            if let coordinate1 = expController.newExperience?.coordinate {
                pin.coordinate = coordinate1
            }

            if let annotationTitle = expController.newExperience?.title {
                pin.title = annotationTitle
            }
            mapView.addAnnotation(pin)
        }
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let experience = annotation as? Experience else { return nil }

        let experienceView = mapView.dequeueReusableAnnotationView(withIdentifier: "ExperienceAnnotationView", for: experience) as! MKMarkerAnnotationView

        experienceView.glyphText = expController.newExperience?.title
        experienceView.markerTintColor = .red

        return experienceView


    }




}

extension MapViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NSLog("Error using location Delegate: \(error)")
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate

        if locations.first != nil {
            expController.location = location
        }
    }

}
