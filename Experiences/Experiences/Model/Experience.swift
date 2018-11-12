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
    var image: UIImage
    var videoURL: URL?
    var soundURL: URL
    var timestamp: String
    
    init(title: String, coordinate: CLLocationCoordinate2D, image: UIImage, videoURL: URL?, soundURL: URL, timestamp: String = Date().description) {
        
        self.coordinate = coordinate
        self.title = title
        self.image = image
        self.videoURL = videoURL
        self.soundURL = soundURL
        self.timestamp = timestamp
        
    }
    
}
