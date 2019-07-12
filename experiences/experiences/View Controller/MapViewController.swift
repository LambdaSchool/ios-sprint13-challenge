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
	let locationManager = CLLocationManager()
	
	@IBOutlet var mapview: MKMapView!
	@IBOutlet var postButton: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		requestLocationAccess()
		
	}

	@IBAction func postButtonPressed(_ sender: Any) {
		print("post")
		print((locationManager.location?.coordinate)!)
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
}

