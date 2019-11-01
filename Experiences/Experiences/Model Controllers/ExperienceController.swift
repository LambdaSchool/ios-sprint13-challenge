//
//  ExperienceController.swift
//  Experiences
//
//  Created by Ciara Beitel on 11/1/19.
//  Copyright © 2019 Ciara Beitel. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class ExperienceController {
    var experiences: [Experience] = []
    
    func createExp(with title: String, image: UIImage, timestamp: Date = Date(), geotag: CLLocationCoordinate2D?) {
        let experience = Experience(title: title, image: image, timestamp: timestamp, geotag: geotag)
    }
}
