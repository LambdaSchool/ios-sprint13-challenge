//
//  CoordinateRegion.swift
//  Experiences
//
//  Created by Benjamin Hakes on 2/22/19.
//  Copyright © 2019 Benjamin Hakes. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

struct CoordinateRegion {
    
    init(origin: (longitude: Double, latitude: Double), size: (width: Double, height: Double)) {
        self.origin = (longitude: min(max(origin.longitude, -180), 180), latitude: min(max(origin.latitude, -90), 90))
        let farPoint = (longitude: self.origin.longitude + size.width, latitude: self.origin.latitude + size.height)
        self.farPoint = (longitude: min(max(farPoint.longitude, -180), 180), latitude: min(max(farPoint.latitude, -90), 90))
    }
    
    init(originLong: Double, originLat: Double, width: Double, height: Double) {
        self.init(origin: (longitude: originLong, latitude: originLat), size: (width: width, height: height))
    }
    
    init(originCoordinate: CLLocationCoordinate2D, width: Double, height: Double) {
        let origin = (longitude: originCoordinate.longitude, latitude: originCoordinate.latitude)
        self.init(origin: origin, size: (width: width, height: height))
    }
    
    init(mapRect: MKMapRect) {
        let region = MKCoordinateRegion(mapRect)
        let origin = (longitude: region.center.longitude - region.span.longitudeDelta/2.0,
                      latitude: region.center.latitude - region.span.latitudeDelta/2.0)
        let size = (width: region.span.longitudeDelta, height: region.span.latitudeDelta)
        self.init(origin: origin, size: size)
    }
    
    // MARK: Properties
    
    var origin: (longitude: Double, latitude: Double)
    var farPoint: (longitude: Double, latitude: Double)
    var size: (width: Double, height: Double) {
        return (width: farPoint.longitude - origin.longitude, height: farPoint.latitude - origin.latitude)
    }
}
