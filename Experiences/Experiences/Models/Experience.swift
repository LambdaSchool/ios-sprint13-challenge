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
    
  // MARK: - Properties
    var experienceTitle: String
    var media: [Media]
    let timestamp: Date
    let geotag: CLLocationCoordinate2D!
    
    init(title: String,
         imageURL: URL?,
         audioURL: URL?,
         videoURL: URL?,
         timestamp: Date = Date(),
         geotag: CLLocationCoordinate2D? = nil) {
        
        self.experienceTitle = title
        self.timestamp = timestamp
        self.geotag = geotag ?? Location.trickDog
        self.media = [Media(mediaType: .image, url: imageURL),
                      Media(mediaType: .audio, url: videoURL),
                      Media(mediaType: .video, url: audioURL )]
        
    }
    
    var savedMedia: [Media] {
        media.filter { $0.url != nil }
    }
    
    var savedMediaTypes: [String] {
        savedMedia.compactMap { $0.mediaType.rawValue}
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
        if savedMedia.count == 0 {
           return "No Experiences."
        } else {
            return "Experience stored: \(savedMediaTypes.joined(separator: ", "))"
        }
    }
}
