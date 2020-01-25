//
//  ExperienceAnnotation.swift
//  Experiences
//
//  Created by Bobby Keffury on 1/24/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import Foundation
import MapKit

class ExperienceAnnotation: NSObject, Decodable {
    
    
    let city: String
    let country: String
    let longitude: Double
    let latitude: Double
    
    internal init(city: String, country: String, longitude: Double, latitude: Double) {
        self.city = city
        self.country = country
        self.longitude = longitude
        self.latitude = latitude
    }
}

extension ExperienceAnnotation: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var title: String? {
        city
    }
    
    var subtitle: String? {
        country
    }
}
