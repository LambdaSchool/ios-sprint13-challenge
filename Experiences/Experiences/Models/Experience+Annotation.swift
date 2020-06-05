//
//  Experience+Annotation.swift
//  Experiences
//
//  Created by Jake Connerly on 11/1/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import Foundation
import MapKit

class ExperienceAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    
    init?(experience: Experience) {
        guard let coordinate = experience.geotag else { return nil }
        
        self.title = experience.title
        self.coordinate = coordinate
    }
}
