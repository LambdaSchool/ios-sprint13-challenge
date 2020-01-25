//
//  Experience+MKAnnotation.swift
//  Experiences
//
//  Created by Joel Groomer on 1/25/20.
//  Copyright © 2020 Julltron. All rights reserved.
//

import MapKit

extension Experience: MKAnnotation {
    public var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
