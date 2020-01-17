//
//  Experience.swift
//  Experiences
//
//  Created by Brandi Bailey on 1/17/20.
//  Copyright © 2020 Brandi Bailey. All rights reserved.
//

import Foundation
import CoreLocation

enum MediaType: String {
    case image
    case video
    case audio
}

class Experience {
    
    var mediaURL: URL
    let mediaType: MediaType
    let timestamp: Date
    var id: String?
    var geotag: CLLocationCoordinate2D?
    
    static private let mediaKey = "media"
    static private let mediaTypeKey = "mediaType"
    static private let timestampKey = "timestamp"
    static private let idKey = "id"
    static private let latitudeKey = "latitude"
    static private let longitudeKey = "longitude"
    
    init(title: String, mediaURL: URL, mediaType: MediaType, timestamp: Date = Date(), geotag: CLLocationCoordinate2D?) {
        self.mediaURL = mediaURL
        self.mediaType = mediaType
        self.timestamp = timestamp
        self.geotag = geotag
    }
    
    init?(dictionary: [String : Any], id: String) {
        guard let mediaURLString = dictionary[Experience.mediaKey] as? String,
            let mediaURL = URL(string: mediaURLString),
            let mediaTypeString = dictionary[Experience.mediaTypeKey] as? String,
            let mediaType = MediaType(rawValue: mediaTypeString),
            let timestampTimeInterval = dictionary[Experience.timestampKey] as? TimeInterval else { return nil }
        
        
        self.mediaURL = mediaURL
        self.mediaType = mediaType
        self.timestamp = Date(timeIntervalSince1970: timestampTimeInterval)
        self.id = id
        
        guard let latitude = dictionary[Experience.latitudeKey] as? CLLocationDegrees,
            let longitude = dictionary[Experience.longitudeKey] as? CLLocationDegrees else { return }
        
        self.geotag = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
