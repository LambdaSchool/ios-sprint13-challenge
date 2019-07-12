//
//  Experience.swift
//  experiences
//
//  Created by Hector Steven on 7/12/19.
//  Copyright © 2019 Hector Steven. All rights reserved.
//

import Foundation
import MapKit

class Experience: NSObject {
	var title: String?
	var subtitle: String?
	var coordinate: CLLocationCoordinate2D
	
	init(title: String, coordinate: CLLocationCoordinate2D) {
		self.title = title
		self.coordinate = coordinate
		subtitle = "\(title) expericence"
		audio = title
		video = title
	}
	
	
	var audio: String?
	var video: String?
	var image: UIImage?
}
