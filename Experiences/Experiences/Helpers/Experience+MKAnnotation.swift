//
//  Experience+MKAnnotation.swift
//  Experiences
//
//  Created by Sal B Amer on 5/19/20.
//  Copyright © 2020 Sal B Amer. All rights reserved.
//

import MapKit

extension Experience: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        guard let geotag = geoLocation else { return CLLocationCoordinate2D() }
        return CLLocationCoordinate2D(latitude: geotag.latitude, longitude: geotag.longitude)
    }

    var title: String? {
        newTitle
    }
}

