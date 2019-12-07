//
//  Experience+MKAnnotation.swift
//  Experiences
//
//  Created by macbook on 12/7/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import MapKit

extension Experience: MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    var subtitle: String? {
        return note
    }
}
