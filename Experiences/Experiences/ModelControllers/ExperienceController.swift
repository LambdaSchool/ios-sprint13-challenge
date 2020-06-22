//
//  ExperienceController.swift
//  Experiences
//
//  Created by Michael Redig on 10/4/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import Foundation
import CoreData

enum ExperienceType: String, CaseIterable {
	case photo
	case video
	case audio
}

protocol ExperienceControllerAccessor: AnyObject {
	var experienceController: ExperienceController? { get set }
}

class ExperienceController {

	/// only access from main thread
	private(set) var experiences: [Experience] = []
	let locationManager = LocationRequester()

	init() {
		updateExperiences()
		locationManager.requestAuth()
		locationManager.startTrackingLocation()
		setupFolders()
	}

	private func setupFolders() {
		guard let documentsFolder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { fatalError("Something went catastrophically wrong.") }
		do {
			for type in ExperienceType.allCases {
				try FileManager.default.createDirectory(at: documentsFolder.appendingPathComponent(type.rawValue), withIntermediateDirectories: true, attributes: nil)
			}
		} catch {
			NSLog("Error creating directory: \(error)")
		}
	}
	
	func createExperience(titled title: String, tempMediaURL: URL, type: ExperienceType, latitude: Double, longitude: Double) {
		guard let documentsFolder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
		let name = tempMediaURL.lastPathComponent
		let destination = documentsFolder.appendingPathComponent(type.rawValue).appendingPathComponent(name)

		do {
			try FileManager.default.moveItem(at: tempMediaURL, to: destination)
		} catch {
			NSLog("Error moving file to permanent storage: \(error)")
		}

		let context = CoreDataStack.shared.mainContext
		context.performAndWait {
			let savedURL = URL(fileURLWithPath: type.rawValue).appendingPathComponent(name)
			Experience(title: title, mediaURL: savedURL, longitude: longitude, latitude: latitude, context: context)
			try? CoreDataStack.shared.save(context: context)
		}
		updateExperiences()
	}

	private func updateExperiences() {
		let moc = CoreDataStack.shared.mainContext
		moc.performAndWait {
			do {
				let fetchRequest: NSFetchRequest<Experience> = Experience.fetchRequest()
				let experiences = try moc.fetch(fetchRequest)
				self.experiences = experiences
			} catch {
				NSLog("Error fetching experiences: \(error)")
			}
		}
	}
}
