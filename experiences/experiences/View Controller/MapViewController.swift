//
//  ViewController.swift
//  experiences
//
//  Created by Hector Steven on 7/12/19.
//  Copyright © 2019 Hector Steven. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
	let experienceController = ExperienceController()
	
	let locationManager = CLLocationManager()
	
	@IBOutlet var mapview: MKMapView!
	@IBOutlet var postButton: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		requestLocationAccess()
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		mapview.reloadInputViews()
		
		mapview.delegate = self
		
		mapview?.addAnnotations(experienceController.experinces)
		
		
		mapview.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "ExperienceAnotationView")
	}

	@IBAction func postButtonPressed(_ sender: Any) {
		print("post")
	}
	
	
	func requestLocationAccess() {
		let status = CLLocationManager.authorizationStatus()
		
		switch status {
		case .authorizedAlways, .authorizedWhenInUse:
			return
		case .denied, .restricted:
			print("location access denied")
		default:
			locationManager.requestWhenInUseAuthorization()
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "PostViewController" {
			guard let vc = segue.destination as? PostViewController else { return }
			experienceController.currentLocation = locationManager.location?.coordinate
			vc.experienceController = experienceController
		}
	}
	
}

extension MapViewController: MKMapViewDelegate {
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "ExperienceAnotationView", for: annotation) as! MKMarkerAnnotationView
		
		

		
		
		annotationView.glyphTintColor = .white
		annotationView.markerTintColor = .black
		annotationView.canShowCallout = true
	
		let dv = DetailView(frame: .zero)
		annotationView.detailCalloutAccessoryView = dv

		return annotationView
	}
	
	
	func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
		
	}
}
