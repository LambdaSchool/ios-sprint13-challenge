//
//  Experience.swift
//  Experiences
//
//  Created by Dillon P on 3/22/20.
//  Copyright © 2020 Lambda iOSPT3. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class Experience: NSObject, MKAnnotation {
    var name: String
    var imageData: Data
    var audioData: Data
    var videoData: Data
    
    var coordinate: CLLocationCoordinate2D
    var title: String? {
        return name
    }
    
    
    init(name: String, imageData: Data, audioData: Data, videoData: Data, coordinate: CLLocationCoordinate2D) {
        self.name = name
        self.imageData = imageData
        self.audioData = audioData
        self.videoData = videoData
        self.coordinate = coordinate
    }
}

