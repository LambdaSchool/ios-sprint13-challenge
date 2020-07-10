//
//  Experience.swift
//  Experiences
//
//  Created by Enzo Jimenez-Soto on 7/10/20.
//  Copyright © 2020 Enzo Jimenez-Soto. All rights reserved.
//

import Foundation
import MapKit

class Experience: NSObject {
    var title: String?
    var audioClip: URL?
    var image: UIImage?
    var videoClip: URL?
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
