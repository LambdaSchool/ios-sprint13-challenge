//
//  PostAnnotation.swift
//  LambdaTimeline
//
//  Created by Spencer Curtis on 10/18/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import Foundation
import MapKit

class ExperienceAnnotation: NSObject, MKAnnotation {

    init?(experience: Experience) {
        guard let coordinate = experience.geotag else { return nil }
        
        self.title = experience.title
        self.coordinate = coordinate
    }
    
    var title: String?
    var coordinate: CLLocationCoordinate2D
}

