//
//  Experience.swift
//  Experiences
//
//  Created by Sean Hendrix on 1/18/19.
//  Copyright © 2019 Sean Hendrix. All rights reserved.
//

import Foundation
import MapKit


class Experience: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var videoURL: URL
    var audioURL: URL
    var imageData: Data
    
    init(title: String, coordinate: CLLocationCoordinate2D, videoURL: URL, audioURL: URL, imageData: Data) {
        self.title = title
        self.coordinate = coordinate
        self.videoURL = videoURL
        self.audioURL = audioURL
        self.imageData = imageData
    }
    
    
}
