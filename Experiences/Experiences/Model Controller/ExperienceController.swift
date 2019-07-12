//
//  ExperienceController.swift
//  Experiences
//
//  Created by Mitchell Budge on 7/12/19.
//  Copyright © 2019 Mitchell Budge. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class ExperienceController {
    
    var experiences: [Experience] = []
    
    func createExperience(coordinate: CLLocationCoordinate2D, title: String?, image: UIImage?, audio: URL?, video: URL?) {
        let newExperience = Experience(coordinate: coordinate, title: title, image: image, audio: audio, video: video)
        experiences.append(newExperience)
    }
}
