//
//  Experience.swift
//  Experiences
//
//  Created by Dennis Rudolph on 1/17/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class Experience: NSObject {
    let name: String
    let image: UIImage?
    let audioURL: URL?
    let videoURL: URL?
    let latitude: Double
    let longitude: Double
    
    init(name: String, image: UIImage? = nil, audioURL: URL? = nil, videoURL: URL? = nil, latitude: Double, longitude: Double) {
        self.name = name
        self.image = image
        self.audioURL = audioURL
        self.videoURL = videoURL
        self.latitude = latitude
        self.longitude = longitude
    }
    
}

extension Experience: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var title: String? {
        return name
    }
}
