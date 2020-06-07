//
//  Location.swift
//  Experiences
//
//  Created by Kenny on 6/6/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import MapKit

struct Location: Codable {
    var latitude: Double
    var longitude: Double

    var clLocationRep: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
