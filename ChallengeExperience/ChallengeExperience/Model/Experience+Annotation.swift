//
//  Experience+Annotation.swift
//  ChallengeExperience
//
//  Created by Michael Flowers on 9/28/19.
//  Copyright © 2019 Michael Flowers. All rights reserved.
//

import MapKit

extension Experience: MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D {
        return location
    }
    
    var title: String? {
        return name
    }
}
