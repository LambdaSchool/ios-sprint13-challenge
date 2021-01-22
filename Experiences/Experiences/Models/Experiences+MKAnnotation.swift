//
//  Experiences+MKAnnotation.swift
//  Experiences
//
//  Created by Christopher Devito on 5/8/20.
//  Copyright © 2020 Christopher Devito. All rights reserved.
//

import Foundation
import MapKit

extension Experience: MKAnnotation {
    var  coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    
}
