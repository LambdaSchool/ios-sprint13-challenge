//
//  Experience.swift
//  Experiences
//
//  Created by Josh Kocsis on 9/11/20.
//  Copyright © 2020 Josh Kocsis. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class Experience: NSObject {
    let titleName: String
    let image: UIImage
    let latitude: Double
    let longitude: Double

    init(titleName: String, image: UIImage, latitude: Double, longitude: Double) {
        self.titleName = titleName
        self.image = image
        self.latitude = latitude
        self.longitude = longitude
    }
}

extension Experience: MKAnnotation {
var coordinate: CLLocationCoordinate2D {
    CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    var title: String? { titleName }
}
