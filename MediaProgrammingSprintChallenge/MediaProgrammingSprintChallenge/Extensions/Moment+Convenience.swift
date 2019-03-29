//
//  Moment+Convenience.swift
//  MediaProgrammingSprintChallenge
//
//  Created by Nathanael Youngren on 3/29/19.
//  Copyright © 2019 Nathanael Youngren. All rights reserved.
//

import CoreData
import MapKit

extension Moment: MKAnnotation {
    
    public var coordinate: CLLocationCoordinate2D {
        let lat = CLLocationDegrees(self.latitude)
        let long = CLLocationDegrees(self.longitude)
        
        return CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
    
    convenience init(caption: String, imageURL: URL, videoURL: URL, audioURL: URL, longitude: Double, latitude: Double,  context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.caption = caption
        self.imageURL = imageURL
        self.videoURL = videoURL
        self.audioURL = audioURL
        self.longitude = longitude
        self.latitude = latitude
    }
}
