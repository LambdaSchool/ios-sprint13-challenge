//
//  ExperiencePost.swift
//  11-7-20 iosLambdaExperiencesSprintChallenge
//
//  Created by BrysonSaclausa on 11/7/20.
//

import Foundation
import MapKit
import CoreLocation

enum MediaType {
    case image(UIImage)
}

struct Locations {
    static let randomLocation = CLLocationCoordinate2D(latitude: 36.1569, longitude: -115.3345)
}

class Post: NSObject {
    let title: String?
    let mediaType: MediaType
    let timestamp: Date
    var id: String?
    let location: CLLocationCoordinate2D
    
    init(title: String?, mediaType: MediaType, timestamp: Date = Date(), location: CLLocationCoordinate2D? = nil) {
        self.mediaType = mediaType
        self.title = title
        self.timestamp = timestamp
        self.location = location ?? Locations.randomLocation
    }
    
}
