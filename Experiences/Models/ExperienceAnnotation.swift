//
//  ExperienceAnnotation.swift
//  Experiences
//
//  Created by macbook on 1/17/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
import MapKit

class ExperienceAnnotation: NSObject, MKAnnotation {
    
    init?(experience: Experience) {
        guard let coordinate = experience.geotag else { return nil }
        
        self.title = experience.title
        self.subtitle = experience.note
        self.coordinate = coordinate
    }
    
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
}
