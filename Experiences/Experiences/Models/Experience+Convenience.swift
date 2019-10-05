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

	var experienceType: ExperienceType? {
		if mediaURL?.lastPathComponent.hasSuffix("caf") == true {
			return ExperienceType.audio
		}
		if mediaURL?.lastPathComponent.hasSuffix("mov") == true {
			return ExperienceType.video
		}
		if mediaURL?.lastPathComponent.hasSuffix("jpg") == true {
			return ExperienceType.photo
		}
		return nil
	}

	var fullURL: URL? {
		guard let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
		guard let mediaURL = mediaURL else { return nil }
		return documents.appendingPathComponent(mediaURL.path)
	}

	@discardableResult convenience init(title: String, mediaURL: URL, longitude: Double, latitude: Double, id: UUID = UUID(), context: NSManagedObjectContext) {
		self.init(context: context)
		self.title = title
		self.mediaURL = mediaURL
		self.longitude = longitude
		self.latitude = latitude
		self.id = id
		self.timestamp = Date()
	}
}

extension Experience: MKAnnotation {
	public var coordinate: CLLocationCoordinate2D {
		CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
	}
}
