//
//  Experience.swift
//  Experiences
//
//  Created by Gerardo Hernandez on 5/20/20.
//  Copyright © 2020 Gerardo Hernandez. All rights reserved.
//

import Foundation
import MapKit


enum MediaType: String, CaseIterable {
      case image, audio, video
  }

struct Location {
    static let trickDog = CLLocationCoordinate2D(latitude: 37.7600297, longitude: 122.4109439)
}

class Experience: NSObject {
    
  
    
    var experienceTitle: String
    var media: [Media]
    //TODO: Add a
    let geotag: CLLocationCoordinate2D!
    let timestamp: Date
    
    init(title: String, imageURL: URL?, videoURL: URL?, audioURL: URL?, geotag: CLLocationCoordinate2D? = nil, timestamp: Date = Date()) {
        self.experienceTitle = title
        self.geotag = geotag ?? Location.trickDog
        self.timestamp = timestamp
        self.media = [Media(mediaType: .image, url: imageURL),
                      Media(mediaType: .video, url: videoURL),
                      Media(mediaType: .audio, url: audioURL )]
        
    }
    
    var storedMedia: [Media] {
        media.filter { $0.url != nil}
    }
    
    var storedMediaTypes: [String] {
        storedMedia.compactMap { $0.mediaType.rawValue}
    }
    
    struct Media {
      
        let mediaType: MediaType
        let url: URL?
    }
}


extension Experience: MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D {
        geotag
    }
    
    var title: String? {
        experienceTitle
    }
    
    var subtitle: String? {
        if storedMedia.count == 0 {
           return "No Experiences."
        } else {
            return "Experience stored: \(storedMediaTypes.joined(separator: ", ."))"
        }
    }
}
