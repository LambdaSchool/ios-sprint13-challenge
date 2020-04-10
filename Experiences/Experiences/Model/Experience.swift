//
//  Experience.swift
//  Experiences
//
//  Created by Keri Levesque on 4/10/20.
//  Copyright © 2020 Keri Levesque. All rights reserved.
//

import Foundation
import MapKit

class Experience: NSObject, MKAnnotation {
  
//MARK: Properties
    var title: String?
    var subtitle: String?
    var media: [Media] = []
   
    var coordinate: CLLocationCoordinate2D
    var createdTimestamp: Date
    var updatedTimeStamp: Date?
    
//MARK: Initializer
    init (title: String, subtitle: String, coordinate: CLLocationCoordinate2D, createdDate: Date = Date()) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        self.createdTimestamp = createdDate
    }
 
// MARK: Methods
    func addMedia (mediaType: MediaType, url: URL?, data: Data? = nil) {
        media.append(Media(mediaType: mediaType, url: url, data: data))
    }
    
    func addMedia (media: Media) {
        self.media.append(media)
    }
}
