//
//  Entry+MKAnnotation.swift
//  ExperinceJournal
//
//  Created by Lambda_School_Loaner_218 on 2/14/20.
//  Copyright © 2020 Lambda_School_Loaner_218. All rights reserved.
//

import Foundation
import MapKit

extension Entry: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        guard let geoTag = geoTag else { return CLLocationCoordinate2D() }
        return CLLocationCoordinate2D(latitude: geoTag.latitude, longitude: geoTag.longitude)
    }
    
    var title: String? {
        entryTitle
    }
}
