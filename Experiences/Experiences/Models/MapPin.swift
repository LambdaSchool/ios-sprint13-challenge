//
//  MapPin.swift
//  Experiences
//
//  Created by Lambda_School_Loaner_268 on 5/8/20.
//  Copyright © 2020 Lambda. All rights reserved.
//

import Foundation
import MapKit
class MapPin : NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var experience: Experience

    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String, experience: Experience) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.experience = experience
    }
}
