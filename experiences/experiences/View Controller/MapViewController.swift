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
		mapview.delegate = self
		mapview?.addAnnotations(experienceController.experinces)
		experienceController.currentLocation = locationManager.location?.coordinate
		
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
			vc.experienceController = experienceController
		}
	}
	
}

extension MapViewController: MKMapViewDelegate {
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		if annotation is MKUserLocation { return nil }
		
		return nil
	}
}
