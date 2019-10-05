//
//  MapVC.swift
//  Experiences
//
//  Created by Jeffrey Santana on 10/4/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController {

	// MARK: - IBOutlets
	
	@IBOutlet weak var mapView: MKMapView!
	@IBOutlet weak var addBtn: UIButton!
	@IBOutlet weak var currentLocationBtn: UIButton!
	@IBOutlet var mapLongPressGesture: UILongPressGestureRecognizer!
	
	// MARK: - Properties
	
	let locationManager = CLLocationManager()
	var userLocation: CLLocation? {
		mapView.userLocation.location
	}
	var experiences = [Experience]()
	
	// MARK: - Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupMap()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		focusMapRegion(over: userLocation)
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
		focusMapRegion(over: userLocation)
	}
	
	@IBAction func mapLongPressed(_ sender: UILongPressGestureRecognizer) {
		switch sender.state {
		case .ended:
			let location = sender.location(in: mapView)
			let coordinate = mapView.convert(location,toCoordinateFrom: mapView)
			
			createAnnotation(at: coordinate)
		default:
			break
		}
	}
	// MARK: - Helpers
	
	private func setupMap() {
		locationManager.requestWhenInUseAuthorization()
		
		mapView.delegate = self
		mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "ExperienceView")
		
		focusMapRegion(over: userLocation)
	}
	
	private func focusMapRegion(over location: CLLocation?) {
		guard let someLocation = location else { return }
		
		let userCoordinate = someLocation.coordinate
		
		let center = CLLocationCoordinate2D(latitude: userCoordinate.latitude, longitude: userCoordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
		
		mapView.setRegion(region, animated: true)
	}
	
	private func createAnnotation(at coordinate: CLLocationCoordinate2D) {
//		let annotation = MKPointAnnotation()
//		annotation.coordinate = coordinate
		
		let newExperience = Experience(caption: "Cool!", location: coordinate, videoUrl: nil, audioUrl: nil)
		mapView.addAnnotation(newExperience)
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
		guard let experience = annotation as? Experience else { return nil }

		let identifier = "ExperienceView"
		guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView else { return  nil }

		annotationView.canShowCallout = true
		
		let detailView = PinDetailsView(frame: .zero)
		detailView.experience = experience
		annotationView.detailCalloutAccessoryView = detailView

		return annotationView
	}

	func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
		
	}
}

extension MapVC: SearchTableVCDelegate {
	func didSelectLocation(_ location: CLLocation) {
		createAnnotation(at: location.coordinate)
		focusMapRegion(over: location)
	}
}
