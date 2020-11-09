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

class XperiencePost: NSObject {
    let title: String?
    let mediaType: MediaType
    var id: String?
    let location: CLLocationCoordinate2D
    
    init(title: String?, mediaType: MediaType, location: CLLocationCoordinate2D? = nil) {
        self.mediaType = mediaType
        self.title = title
        self.location = location ?? Locations.randomLocation
    }
    
}
