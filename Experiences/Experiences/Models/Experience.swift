//
//  Experience.swift
//  Experiences
//
//  Created by Mark Poggi on 6/4/20.
//  Copyright © 2020 Mark Poggi. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class Experience: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D


    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}
