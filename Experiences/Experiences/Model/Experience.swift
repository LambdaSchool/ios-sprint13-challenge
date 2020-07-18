//
//  Experience.swift
//  Experiences
//
//  Created by Claudia Maciel on 7/17/20.
//  Copyright © 2020 thecoderpilot. All rights reserved.
//

import Foundation
import MapKit

class Experience: NSObject {
    let title: String?
    let audioURL: URL?
    let image: Data?
    
    let longitude: Double
    let latitude: Double
    
    init(title: String, audioURL: URL?, image: Data?, longitude: Double, latitude: Double) {
        self.title = title
        self.audioURL = audioURL
        self.image = image
        self.longitude = longitude
        self.latitude = latitude
    }
}

extension Experience: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
