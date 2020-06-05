//
//  Experience+Annotation.swift
//  Experiences
//
//  Created by Brandi Bailey on 1/20/20.
//  Copyright © 2020 Brandi Bailey. All rights reserved.
//

import MapKit

extension Experience: MKAnnotation {
    
    public var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
//    var title: String? {
//        title
//    }
//    
//    var subtitle: String? {
//        ""
//    }
}
