//
//  ExperienceAnnotation.swift
//  Experiences
//
//  Created by Ciara Beitel on 11/1/19.
//  Copyright © 2019 Ciara Beitel. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

class ExperienceAnnotation: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D

    init?(experience: Experience) {
        self.title = experience.title
        self.coordinate = experience.geotag
    }
}
