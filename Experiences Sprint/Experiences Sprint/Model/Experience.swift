//
//  Experience.swift
//  Experiences Sprint
//
//  Created by Harmony Radley on 7/10/20.
//  Copyright © 2020 Harmony Radley. All rights reserved.
//

import Foundation
import MapKit

class Experience: NSObject {
    var title: String?
    var image: UIImage?
    var audio: URL?
    var latitude: Double?
    var longitude: Double?
}

extension Experience: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        let lat = latitude ?? 0.0
        let long = longitude ?? 0.0
        return CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
}
