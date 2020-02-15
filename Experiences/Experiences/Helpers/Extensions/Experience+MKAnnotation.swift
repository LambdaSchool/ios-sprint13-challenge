//
//  Experience+MKAnnotation.swift
//  Experiences
//
//  Created by Chad Rutherford on 2/15/20.
//  Copyright © 2020 Chad Rutherford. All rights reserved.
//

import MapKit
import Foundation

extension Experience: MKAnnotation {
    public var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var pinTitle: String {
        title ?? ""
    }
}
