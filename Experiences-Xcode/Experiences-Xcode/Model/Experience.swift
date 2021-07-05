//
//  Experience.swift
//  Experiences-Xcode
//
//  Created by Austin Potts on 3/13/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
import MapKit


class Experience: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var videoURL: URL?
    var audioURL: URL?
    var imageData: Data?
    
    init(title: String, coordinate: CLLocationCoordinate2D, videoURL: URL? = nil, audioURL: URL? = nil, imageData: Data? = nil) {
        self.title = title
        self.videoURL = videoURL
        self.audioURL = audioURL
        self.coordinate = coordinate
        self.imageData = imageData
    }
}
