//
//  Experience+Mapping.swift
//  Experiences
//
//  Created by Thomas Cacciatore on 7/12/19.
//  Copyright © 2019 Thomas Cacciatore. All rights reserved.
//

import MapKit

extension Experience: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        return location
    }
}
