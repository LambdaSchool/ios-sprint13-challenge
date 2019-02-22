//
//  GeoViewController.swift
//  LambdaTimeline
//
//  Created by Sergey Osipyan on 2/21/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class GeoViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    private let locationManager = CLLocationManager()
    var curentLocation: CLLocationCoordinate2D?
    
    let annotation = MKPointAnnotation()
    
//    func addPin() {
//        let annotation = MKPointAnnotation()
//        let centerCoordinate = CLLocationCoordinate2D(latitude: 20.836864, longitude:-156.874269)
//        annotation.coordinate = centerCoordinate
//        annotation.title = "Lanai, Hawaii"
//        mapView.addAnnotation(annotation)
//    }
    
//    func focusMapView() {
//        
//       
//        let mapCenter = CLLocationCoordinate2DMake(20.836864, -156.874269)
//        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
//        let region = MKCoordinateRegion(center: mapCenter, span: span)
//        mapView.region = region
//        
//        
//    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        addPin()
//        focusMapView()

        let userTrackingButton = MKUserTrackingButton(mapView: mapView)
        userTrackingButton.translatesAutoresizingMaskIntoConstraints = false
        mapView.addSubview(userTrackingButton)

        userTrackingButton.rightAnchor.constraint(equalTo: mapView.rightAnchor, constant: -5).isActive = true
        userTrackingButton.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 45).isActive = true

        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "PostAnnotationView")

        //
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if #available(iOS 8.0, *) {
            locationManager.requestAlwaysAuthorization()
        } else {
            // Fallback on earlier versions
        }
        locationManager.startUpdatingLocation()
        
        // add gesture recognizer
//        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(GeoViewController.mapLongPress(_:))) // colon needs to pass through info
//        longPress.minimumPressDuration = 1.5 // in seconds
//        //add gesture recognition
//        mapView.addGestureRecognizer(longPress)
    }
    
//    @objc func mapLongPress(_ recognizer: UIGestureRecognizer) {
//
//        print("A long press has been detected.")
//
//        let touchedAt = recognizer.location(in: self.mapView) // adds the location on the view it was pressed
//        let touchedAtCoordinate : CLLocationCoordinate2D = mapView.convert(touchedAt, toCoordinateFrom: self.mapView) // will get coordinates
//
//        let newPin = MKPointAnnotation()
//        newPin.coordinate = touchedAtCoordinate
//        mapView.addAnnotation(newPin)
//
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last! as CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        
        let newPin = MKPointAnnotation()
        newPin.coordinate = center
        newPin.title = "test"
        mapView.addAnnotation(newPin)
        
        //set region on the map
        self.mapView.setRegion(region, animated: true)
        self.locationManager.stopUpdatingLocation()
        
        
    }
//
//
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        guard annotation is MKPointAnnotation else { return nil }
//
//        let identifier = "PostAnnotationView"
//        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
//
//        if annotationView == nil {
//            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//            annotationView!.canShowCallout = true
//        } else {
//            annotationView!.annotation = annotation
//        }
//
//        return annotationView
//    }
    
}
