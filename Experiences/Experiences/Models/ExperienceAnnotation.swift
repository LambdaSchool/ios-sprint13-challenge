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
        guard let coordinate = experience.geotag else { return nil }
        self.title = experience.title
        self.coordinate = coordinate
    }
}
