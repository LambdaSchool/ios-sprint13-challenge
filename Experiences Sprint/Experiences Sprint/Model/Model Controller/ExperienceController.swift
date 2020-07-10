//
//  ExperienceController.swift
//  Experiences Sprint
//
//  Created by Harmony Radley on 7/10/20.
//  Copyright © 2020 Harmony Radley. All rights reserved.
//

import Foundation
import UIKit

class ExperienceController {
    var experiences: [Experience] = []

    func createExperience(title: String?,
                          image: UIImage?,
                          audio: URL?,
                          latitude: Double,
                          longitude: Double) {

        let newExperience = Experience()

        newExperience.title = title
        newExperience.image = image
        newExperience.audio = audio
        newExperience.latitude = latitude
        newExperience.longitude = longitude

        experiences.append(newExperience)
    }
}
