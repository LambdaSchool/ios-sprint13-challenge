//
//  Experience.swift
//  Experiences
//
//  Created by David Wright on 5/17/20.
//  Copyright © 2020 David Wright. All rights reserved.
//

import Foundation
import MapKit

class Experience: NSObject {
    
    var title: String
    var imageURL: URL?
    var audioURL: URL?
    var videoURL: URL?
    let timestamp: Date
    let location: CLLocationCoordinate2D?
    
    init(title: String,
         imageURL: URL?,
         audioURL: URL?,
         videoURL: URL?,
         timestamp: Date = Date(),
         location: CLLocationCoordinate2D? = nil) {
        
        self.title = title
        self.imageURL = imageURL
        self.audioURL = audioURL
        self.videoURL = videoURL
        self.timestamp = timestamp
        self.location = location
    }
    
    static func == (lhs: Experience, rhs: Experience) -> Bool {
        lhs.timestamp == rhs.timestamp
    }
}
