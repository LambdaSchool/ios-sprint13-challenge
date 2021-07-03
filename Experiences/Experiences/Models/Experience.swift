//
//  Experience.swift
//  Experiences
//
//  Created by Michael Stoffer on 10/3/19.
//  Copyright © 2019 Michael Stoffer. All rights reserved.
//

import Foundation
import MapKit

class Experience: NSObject, MKAnnotation {
    var experienceTitle: String
    var imageData: Data
    var audioURL: URL
    var videoURL: URL
    var coordinate: CLLocationCoordinate2D
    
    init(experienceTitle: String, imageData: Data, audioURL: URL, videoURL: URL, coordinate: CLLocationCoordinate2D) {
        self.experienceTitle = experienceTitle
        self.imageData = imageData
        self.audioURL = audioURL
        self.videoURL = videoURL
        self.coordinate = coordinate
    }
}
