//
//  Experience.swift
//  Experience
//
//  Created by Lydia Zhang on 5/8/20.
//  Copyright © 2020 Lydia Zhang. All rights reserved.
//

import Foundation
import MapKit

class Experience: NSObject, Codable {
    let latitude: Double
    let longitude: Double
    var expTitle: String
    
    init(latitude: Double, longitude: Double, expTitle: String) {
        self.longitude = longitude
        self.latitude = latitude
        self.expTitle = expTitle
    }
}
extension Experience: MKAnnotation {

    var coordinate: CLLocationCoordinate2D {

    CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
