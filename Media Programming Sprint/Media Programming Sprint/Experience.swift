//
//  Experience.swift
//  Media Programming Sprint
//
//  Created by Lambda_School_Loaner_95 on 4/28/19.
//  Copyright © 2019 JS. All rights reserved.
//

import Foundation
import CoreLocation

enum MediaType: String {
    case image
    case video
    case audio
}

struct Experience {
    var title: String
    let mediaTypeOne: MediaType
    let mediaTypeTwo: MediaType
    let mediaTypeThree: MediaType
    var geotag: CLLocationCoordinate2D?
}
