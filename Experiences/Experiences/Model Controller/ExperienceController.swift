//
//  ExperienceController.swift
//  Experiences
//
//  Created by Jake Connerly on 11/1/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import Foundation
import CoreLocation

class ExperienceController {
    
    var experiences: [Experience] = []
    
    func createExperience(with title: String, image: Data, audioCommentURL: String, geotag: CLLocationCoordinate2D) {
        let experience = Experience(title: title, image: image, audioCommentURL: audioCommentURL, geotag: geotag)
        experiences.append(experience)
    }
}
