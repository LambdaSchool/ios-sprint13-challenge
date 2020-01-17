//
//  Entry+MKAnnotation.swift
//  Unit4-SprintChallenge1
//
//  Created by Lambda_School_Loaner_204 on 1/17/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import MapKit

extension Entry: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        guard let geotag = geotag else { return CLLocationCoordinate2D() }
        return CLLocationCoordinate2D(latitude: geotag.latitude, longitude: geotag.longitude)
    }

    var title: String? {
        entryTitle
    }
}
