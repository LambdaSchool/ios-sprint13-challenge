//
//  ExperienceController.swift
//  Experiences
//
//  Created by Jessie Ann Griffin on 5/17/20.
//  Copyright © 2020 Jessie Griffin. All rights reserved.
//

import Foundation
import CoreLocation

class ExperienceController {
    
    private(set) var listOfExperiences: [Experience] = []

    func createExperience(with title: String, at geotag: CLLocationCoordinate2D, from mediaType: MediaType) {
        let experience = Experience(title: title, geotag: geotag, media: mediaType)
        listOfExperiences.append(experience)
    }
}
