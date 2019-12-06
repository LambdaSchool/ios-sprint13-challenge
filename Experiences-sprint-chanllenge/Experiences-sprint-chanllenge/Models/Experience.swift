//
//  Experience.swift
//  Experiences-sprint-chanllenge
//
//  Created by Gi Pyo Kim on 12/6/19.
//  Copyright © 2019 GIPGIP Studio. All rights reserved.
//

import Foundation
import MapKit


class Experience: NSObject {
    let latitude: Double
    let longitude: Double
    let experienceTitle: String
    let imageURL: URL
    let audioURL: URL
    let videoURL: URL
    
    init(latitude: Double, longitude: Double, experienceTitle: String, imageURL: URL, audioURL: URL, videoURL: URL) {
        self.latitude = latitude
        self.longitude = longitude
        self.experienceTitle = experienceTitle
        self.imageURL = imageURL
        self.audioURL = audioURL
        self.videoURL = videoURL
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
