//
//  ExperienceController.swift
//  ExperiencesSprint
//
//  Created by Jorge Alvarez on 3/13/20.
//  Copyright © 2020 Jorge Alvarez. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class ExperienceController {
    var experiences: [Experience] = []
    
    // store in here then add them up with save button
    var comment: String?
    var coordinate: CLLocationCoordinate2D?
    var image: UIImage?
    var audioURL: URL?
    var videoURL: URL?
}
