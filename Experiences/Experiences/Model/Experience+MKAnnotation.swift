//
//  Experience+MKAnnotation.swift
//  Experiences
//
//  Created by Bradley Diroff on 6/6/20.
//  Copyright © 2020 Bradley Diroff. All rights reserved.
//

import MapKit

extension Experience: MKAnnotation {
var coordinate: CLLocationCoordinate2D {
    CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
}

var title: String? {
    message
}

}
