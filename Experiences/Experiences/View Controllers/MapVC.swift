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
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let searchVC = segue.destination as? SearchTableVC {
			searchVC.mapView = mapView
			searchVC.delegate = self
		}
	}
	
	// MARK: - IBActions
	
	@IBAction func addBtnTapped(_ sender: Any) {
		newExperianceTypeSheet()
	}
	
	@IBAction func currentLocationBtnTapped(_ sender: Any) {
		FocusOnUserLocation()
	}
	
	@IBAction func mapLongPressed(_ sender: UILongPressGestureRecognizer) {
		let location = sender.location(in: mapView)
		let coordinate = mapView.convert(location,toCoordinateFrom: mapView)
		
		createAnnotation(at: coordinate)
	}
	// MARK: - Helpers
	
	private func setupMap() {
		locationManager.requestWhenInUseAuthorization()
		
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
	
	private func createAnnotation(at coordinate: CLLocationCoordinate2D) {
		let annotation = MKPointAnnotation()
		annotation.coordinate = coordinate
		mapView.addAnnotation(annotation)
	}
	
	private func newExperianceTypeSheet() {
		let alert = UIAlertController(title: "Experience Type", message: "Select what type of experiance to make", preferredStyle: .actionSheet)
		let audioAction = UIAlertAction(title: "Audio", style: .default) { _ in
			self.performSegue(withIdentifier: "AudioVCSegue", sender: nil)
		}
		let videoAction = UIAlertAction(title: "Video", style: .default) { _ in
			self.performSegue(withIdentifier: "CameraVCSegue", sender: nil)
		}
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		
		[audioAction, videoAction, cancelAction].forEach({ alert.addAction($0) })
		present(alert, animated: true, completion: nil)
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

extension MapVC: SearchTableVCDelegate {
	func didSelectLocation(_ location: CLLocation) {
		createAnnotation(at: location.coordinate)
	}
}
