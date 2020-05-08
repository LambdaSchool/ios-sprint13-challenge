//
//  ExperienceController.swift
//  Experiences
//
//  Created by Karen Rodriguez on 5/8/20.
//  Copyright © 2020 Hector Ledesma. All rights reserved.
//

import Foundation
import MapKit

class ExperienceController {

    var experiences: [Experience] = []

    func createExperience(title: String, content: String, videoURL: String?, imageData: Data?, audioURL: String?, geoTag: CLLocationCoordinate2D) {

        let newExperience = Experience(expTitle: title, content: content, geoTag: geoTag, videoURL: videoURL, imageData: imageData, audioURL: audioURL)
        experiences.append(newExperience)

    }
}
