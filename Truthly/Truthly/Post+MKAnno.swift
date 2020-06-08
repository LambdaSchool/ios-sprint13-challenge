//
//  Post+MKAnno.swift
//  Truthly
//
//  Created by Ezra Black on 6/7/20.
//  Copyright © 2020 Casanova Studios. All rights reserved.
//

import MapKit
extension Post: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        guard let geotag = geotag else { return CLLocationCoordinate2D() }
        return CLLocationCoordinate2D(latitude: geotag.latitude, longitude: geotag.longitude)
    }

    var title: String? {
        postTitle
    }
}
