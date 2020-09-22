//
//  Experience.swift
//  Experiences
//
//  Created by Lambda_School_loaner_226 on 9/21/20.
//  Copyright © 2020 Experiences. All rights reserved.
//

import UIKit
import AVFoundation
import MapKit
import CoreLocation

class Experience: NSObject {
    let name: String
    let latitude: Double
    let longitude: Double
    
    init(name: String, latitude: Double, longitude: Double) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        
    }
}

extension Experience: MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var title: String? {
        name
    }
}
