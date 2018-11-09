//
//  Experience.swift
//  Experiences
//
//  Created by Farhan on 11/9/18.
//  Copyright © 2018 Farhan. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class Experience: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var imageURL: URL
    var videoURL: URL
    var soundURL: URL
    var timestamp: String
    
    init(title: String, coordinate: CLLocationCoordinate2D, imageURL: URL, videoURL: URL, soundURL: URL, timestamp: String = Date().description) {
        
        self.coordinate = coordinate
        self.title = title
        self.imageURL = imageURL
        self.videoURL = videoURL
        self.soundURL = soundURL
        self.timestamp = timestamp
        
    }
    
}
