//
//  ExperienceController.swift
//  Experiences
//
//  Created by Mark Poggi on 6/4/20.
//  Copyright © 2020 Mark Poggi. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class ExperienceController {

    var experiences: [Experience] = []
    var experience: Experience?

    func createExperience(coordinate: CLLocationCoordinate2D, title: String?, image: UIImage?, audio: URL?, video: URL?) {
        let newExperience = Experience(coordinate: coordinate, title: title, image: image, audio: audio, video: video)
        experiences.append(newExperience)
        experience = newExperience
    }
}
