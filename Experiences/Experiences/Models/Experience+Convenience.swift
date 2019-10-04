//
//  Experience+Convenience.swift
//  Experiences
//
//  Created by Michael Redig on 10/4/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import Foundation
import CoreData
import MapKit

extension Experience {

	@discardableResult convenience init(title: String, mediaURL: URL, longitude: Double, latitude: Double, id: UUID = UUID(), context: NSManagedObjectContext) {
		self.init(context: context)
		self.title = title
		self.mediaURL = mediaURL
		self.longitude = longitude
		self.latitude = latitude
		self.id = id
	}
}

extension Experience: MKAnnotation {
	public var coordinate: CLLocationCoordinate2D {
		CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
	}
}
