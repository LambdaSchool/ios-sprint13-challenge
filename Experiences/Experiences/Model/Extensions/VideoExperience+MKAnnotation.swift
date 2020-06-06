//
//  VideoExperience+MKAnnotation.swift
//  Experiences
//
//  Created by Kenny on 6/6/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import MapKit

extension VideoExperience: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
    }

    var title: String? {
        subject
    }

    var subtitle: String? {
        body
    }
}
