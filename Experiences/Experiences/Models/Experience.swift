//
//  Experience.swift
//  Experiences
//
//  Created by John Kouris on 1/25/20.
//  Copyright © 2020 John Kouris. All rights reserved.
//

import Foundation
import MapKit

class Experience: NSObject {
    var experienceTitle: String
    var latitude: Double
    var longitude: Double
    var image: UIImage?
    var audioRecording: URL?
    var videoRecording: URL?
    
    internal init(title: String, latitude: Double, longitude: Double, image: UIImage?, audioRecording: URL?, videoRecording: URL?) {
        self.experienceTitle = title
        self.latitude = latitude
        self.longitude = longitude
        self.image = image
        self.audioRecording = audioRecording
        self.videoRecording = videoRecording
    }
    
}

extension Experience: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var title: String? {
        experienceTitle
    }
    
}
