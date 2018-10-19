//
//  Experience+Convenience.swift
//  Experiences
//
//  Created by Linh Bouniol on 10/19/18.
//  Copyright © 2018 Linh Bouniol. All rights reserved.
//

import Foundation
import CoreData
import MapKit

extension Experience: MKAnnotation {
    convenience init(title: String, imageURL: URL, audioURL: URL, videoURL: URL, latitude: Double, longitude: Double, managedObjectContext: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: managedObjectContext)
        
        self.title = title
        self.imageURL = imageURL
        self.audioURL = audioURL
        self.videoURL = videoURL
        self.latitude = latitude
        self.longitude = longitude
    }
    
    public var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
   
}


