//
//  Experience+Annotation.swift
//  MorseWeek13SprintChallenge
//
//  Created by morse on 1/17/20.
//  Copyright © 2020 morse. All rights reserved.
//

import Foundation
import MapKit

extension Experience: MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var title: String? {
        name
    }
}
