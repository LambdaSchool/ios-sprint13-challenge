//
//  Experience.swift
//  Experiences
//
//  Created by Nonye on 7/10/20.
//  Copyright © 2020 Nonye Ezekwo. All rights reserved.
//

import Foundation
import MapKit

// - title, image, audio ? map maybe

class Experience: NSObject {
    var title: String?
    var image: UIImage?
    var audioClip: URL?
    var latitude: Double? // ?
    var longitude: Double? // ?
}

extension Experience: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        let lat = latitude ?? 0.0
        let long = longitude ?? 0.0
        return CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
}
