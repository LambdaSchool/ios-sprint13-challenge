//
//  Experience+MKAnnotation.swift
//  Experiences
//
//  Created by Kevin Stewart on 7/23/20.
//  Copyright © 2020 Kevin Stewart. All rights reserved.
//

import MapKit

extension Experience: MKAnnotation {
var coordinate: CLLocationCoordinate2D {
    return currentLocation
}

var title: String? {
    name
}

}
