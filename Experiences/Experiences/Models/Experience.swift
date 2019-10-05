//
//  Experience.swift
//  Experiences
//
//  Created by Jeffrey Santana on 10/4/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import Foundation
import MapKit

//init(title: String, timestamp: Date, location: CLLocation, videoUrl: URL?, audioUrl: URL?) {
//	self.title = title
//	self.timestamp = timestamp
//	self.location = location
//	self.videoUrl = videoUrl
//	self.audioUrl = audioUrl
//}

class Experience: NSObject {
	private let location: CLLocationCoordinate2D
	let caption: String
	let timestamp: Date
	var videoUrl: URL?
	var audioUrl: URL?
	var comments: [String]?
	
	init(caption: String, location: CLLocationCoordinate2D, videoUrl: URL?, audioUrl: URL?) {
		self.caption = caption
		self.timestamp = Date()
		self.location = location
		self.videoUrl = videoUrl
		self.audioUrl = audioUrl
	}
}

extension Experience: MKAnnotation {
	var coordinate: CLLocationCoordinate2D {
		location
	}
}
