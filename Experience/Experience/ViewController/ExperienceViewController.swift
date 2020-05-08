//
//  ExperienceViewController.swift
//  Experience
//
//  Created by Lydia Zhang on 5/8/20.
//  Copyright © 2020 Lydia Zhang. All rights reserved.
//

import UIKit
import MapKit

class ExperienceViewController: UIViewController, CLLocationManagerDelegate {
    
    let experience: Experience? = nil
    var location: Location?
    var currentLocation: CLLocation!
    var locationManager = CLLocationManager()
    let newPin = MKPointAnnotation()
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "ExperienceView")
        
        if let location = location {
            switch location {
            case .other:
                print("HI")
            default:

                locationManager.startUpdatingLocation()
                if (CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
                    CLLocationManager.authorizationStatus() ==  .authorizedAlways)
                {
                    currentLocation = locationManager.location
                }
                
                if CLLocationManager.headingAvailable()
                {
                    locationManager.headingFilter = 5
                    locationManager.startUpdatingHeading()
                }
                
                func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
                    mapView.removeAnnotation(newPin)

                    let location = locations.last! as CLLocation

                    let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                    let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))

                    //set region on the map
                    mapView.setRegion(region, animated: true)

                    newPin.coordinate = location.coordinate
                    mapView.addAnnotation(newPin)

                }
            }
        }
    }
    

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddExpSegue" {
            guard let createExpVC = segue.destination as? CreateViewController else {return}
            createExpVC.experience = experience
            createExpVC.location = location
        }
    }
}


extension ExperienceViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "ExperienceView", for: annotation) as? MKMarkerAnnotationView else {
            fatalError("Missing a registered view")
        }

        annotationView.canShowCallout = true

        return annotationView
    }
}
