//
//  Experience+MKAnnotation.swift
//  ExperiencesChallenge
//
//  Created by Ian French on 9/13/20.
//  Copyright © 2020 Ian French. All rights reserved.
//

import MapKit

extension Experience: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        guard let geotag = geotag else { return CLLocationCoordinate2D() }
        return CLLocationCoordinate2D(latitude: geotag.latitude, longitude: geotag.longitude)
    }

    var title: String? {
        experienceTitle
    }
}
