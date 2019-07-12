//
//  ExperienceController.swift
//  experiences
//
//  Created by Hector Steven on 7/12/19.
//  Copyright © 2019 Hector Steven. All rights reserved.
//


import MapKit
class ExperienceController {
	private (set) var experinces: [Experience] = []
	
	func addExperience(title: String, coordinate: CLLocationCoordinate2D) {
		let experince = Experience(title: title, coordinate: coordinate)
		experinces.append(experince)
	}
	
}
