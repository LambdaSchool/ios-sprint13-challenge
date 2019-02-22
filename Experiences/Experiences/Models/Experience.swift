//
//  Experience.swift
//  Experiences
//
//  Created by Benjamin Hakes on 2/22/19.
//  Copyright © 2019 Benjamin Hakes. All rights reserved.
//

import Foundation
import CoreLocation

enum MediaType: String {
    case image
    case audioComment
    case video
}

enum LatLongType: String {
    case latitude
    case longitude
}

class Experience {
    
    init(title: String, audioURL: URL, videoURL: URL, imageURL: URL, geotag: CLLocationCoordinate2D? = nil, timestamp: Date = Date()) {
        self.audioURL = audioURL
        self.videoURL = videoURL
        self.imageURL = imageURL
        self.timestamp = timestamp
        self.geotag = geotag
        self.title = title
    }
    
    init?(dictionary: [String : Any], id: String) {
        guard let audioURLString = dictionary[Experience.audioKey] as? String,
            let audioURL = URL(string: audioURLString),
            let videoURLString = dictionary[Experience.videoKey] as? String,
            let videoURL = URL(string: videoURLString),
            let imageURLString = dictionary[Experience.imageKey] as? String,
            let imageURL = URL(string: imageURLString),
            let title = dictionary[Experience.titleKey] as? String,
            let timestampTimeInterval = dictionary[Experience.timestampKey] as? TimeInterval else { return nil }
        
        
        var geotag: CLLocationCoordinate2D?
        if let geotagDictionary = dictionary[Experience.geotagKey] as? [String: Any],
            let latitude = geotagDictionary["latitude"] as? Double,
            let longitude = geotagDictionary["longitude"] as? Double{
            
            geotag = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        } else {
            geotag = nil
        }
        
        
        self.audioURL = audioURL
        self.videoURL = videoURL
        self.imageURL = imageURL
        self.timestamp = Date(timeIntervalSince1970: timestampTimeInterval)
        self.title = title
        self.id = id
        self.geotag = geotag
    }
    
    var dictionaryRepresentation: [String : Any] {
        var dict: [String: Any] = [Experience.audioKey: audioURL.absoluteString,
                                   Experience.videoKey: videoURL.absoluteString,
                                   Experience.imageKey: imageURL.absoluteString,
                                   Experience.titleKey: title,
                                   Experience.timestampKey: timestamp.timeIntervalSince1970]
        
        
        if let geotag = self.geotag {
            dict[Experience.geotagKey] = [Experience.latitudeKey: geotag.latitude, Experience.longitudeKey: geotag.longitude]
        }
        
        return dict
    }
    
    var audioURL: URL
    var videoURL: URL
    var imageURL: URL
    let timestamp: Date
    var title: String
    var id: String?
    var geotag: CLLocationCoordinate2D?
    

    
    static private let audioKey = "audio"
    static private let videoKey = "video"
    static private let imageKey = "image"
    static private let titleKey = "title"
    static private let timestampKey = "timestamp"
    static private let idKey = "id"
    static private let geotagKey = "geotag"
    static private let latitudeKey = "latitude"
    static private let longitudeKey = "longitude"
}

