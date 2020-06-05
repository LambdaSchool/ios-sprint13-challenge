//
//  MKAnnotation.swift
//  stuff
//
//  Created by Alex Thompson on 5/18/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import MapKit

extension Experience: MKAnnotation {
   
    var coordinate: CLLocationCoordinate2D {
        geotag
    }
    
    var title: String? {
        experienceTitle
    }
}
