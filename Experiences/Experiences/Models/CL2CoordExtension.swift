//
//  CL2CoordExtension.swift
//  Experiences
//
//  Created by Lambda_School_Loaner_268 on 5/10/20.
//  Copyright © 2020 Lambda. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

extension CLLocationCoordinate2D: Equatable {
    static public func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
