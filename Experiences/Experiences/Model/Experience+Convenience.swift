//
//  Experience+Convenience.swift
//  Experiences
//
//  Created by Marlon Raskin on 10/5/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import Foundation
import CoreData
import MapKit

extension Experience {
    @discardableResult convenience init(title: String, imageURL: URL?, audioURL: URL?, videoURL: URL?, latitude: Double, longitude: Double, context: NSManagedObjectContext) {
        self.init(context: context)
        self.title = title
        self.imageURL = imageURL
        self.audioURL = audioURL
        self.videoURL = videoURL
        self.latitude = latitude
        self.longitude = longitude
        self.timestamp = Date()
    }
}

extension Experience: MKAnnotation {
    public var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
