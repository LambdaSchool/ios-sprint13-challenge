//
//  Experience.swift
//  SprintChallengeExperience
//
//  Created by Jerry haaser on 1/17/20.
//  Copyright © 2020 Jerry haaser. All rights reserved.
//

import Foundation
import MapKit

class Experience: NSObject, MKAnnotation {
    var title: String?
    var audioURL: URL
    var videoURL: URL
    var imageData: Data
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, audioURL: URL, videoURL: URL, imageData: Data, coordinate: CLLocationCoordinate2D? = nil) {
        self.title = title
        self.audioURL = audioURL
        self.videoURL = videoURL
        self.imageData = imageData
        self.coordinate = coordinate ?? CLLocationCoordinate2D(latitude: -50.0, longitude: -50.0)
    }
}
