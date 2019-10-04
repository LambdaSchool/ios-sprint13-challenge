//
//  MapVC.swift
//  Experiences
//
//  Created by Jeffrey Santana on 10/4/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapVC: UIViewController {

	// MARK: - IBOutlets
	
	@IBOutlet weak var mapView: MKMapView!
	@IBOutlet weak var addBtn: UIButton!
	@IBOutlet weak var currentLocationBtn: UIButton!
	@IBOutlet var mapLongPressGesture: UILongPressGestureRecognizer!
	
	// MARK: - Properties
	
	let locationManager = CLLocationManager()
	
	// MARK: - Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupMap()
	}
	
	// MARK: - IBActions
	
	@IBAction func addBtnTapped(_ sender: Any) {
		
	}
	
	@IBAction func currentLocationBtnTapped(_ sender: Any) {
		FocusOnUserLocation()
	}
	
	@IBAction func mapLongPressed(_ sender: UILongPressGestureRecognizer) {
		let location = sender.location(in: mapView)
		let coordinate = mapView.convert(location,toCoordinateFrom: mapView)

		// Add annotation:
		let annotation = MKPointAnnotation()
		annotation.coordinate = coordinate
		mapView.addAnnotation(annotation)
	}
	// MARK: - Helpers
	
	private func setupMap() {
		self.locationManager.requestWhenInUseAuthorization()

		if CLLocationManager.locationServicesEnabled() {
			locationManager.delegate = self
			locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
			locationManager.startUpdatingLocation()
		}
		
		mapView.delegate = self
		
		FocusOnUserLocation()
	}
	
	private func FocusOnUserLocation() {
		guard let userLocation = mapView.userLocation.location else { return }
		let userCoordinate = userLocation.coordinate
		
		let center = CLLocationCoordinate2D(latitude: userCoordinate.latitude, longitude: userCoordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
		
		mapView.setRegion(region, animated: true)
	}
}

extension MapVC: MKMapViewDelegate {
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		guard annotation is MKPointAnnotation else { return nil }

		let identifier = "Annotation"
		var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

		if annotationView == nil {
			annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
			annotationView!.canShowCallout = true
		} else {
			annotationView!.annotation = annotation
		}

		return annotationView
	}

	func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
		
	}
}

extension MapVC: CLLocationManagerDelegate {
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

	}
}
