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
	
	var currentLocation: CLLocationCoordinate2D?
	
	func addExperience(experience: Experience) {
		experinces.append(experience)
	}
	
}
