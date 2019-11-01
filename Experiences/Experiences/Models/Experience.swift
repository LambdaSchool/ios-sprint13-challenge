//
//  Experience.swift
//  Experiences
//
//  Created by Ciara Beitel on 11/1/19.
//  Copyright © 2019 Ciara Beitel. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class Experience {
    var title: String
    var image: UIImage
    var timestamp: Date
    var geotag: CLLocationCoordinate2D?
    
    init(title: String, image: UIImage, timestamp: Date = Date(), geotag: CLLocationCoordinate2D?) {
        self.title = title
        self.image = image
        self.timestamp = timestamp
        self.geotag = geotag
    }
}
