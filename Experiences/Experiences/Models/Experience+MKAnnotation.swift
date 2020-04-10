//
//  Experience+MKAnnotation.swift
//  Experiences
//
//  Created by scott harris on 4/10/20.
//  Copyright © 2020 scott harris. All rights reserved.
//

import Foundation
import MapKit

extension Experience: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var title: String? {
        self.experiencetitle
    }
    
    var subtitle: String? {
        nil
    }
}
