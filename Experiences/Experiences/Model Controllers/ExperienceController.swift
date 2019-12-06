//
//  ExperienceController.swift
//  Experiences
//
//  Created by Isaac Lyons on 12/6/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import MapKit

class ExperienceController {
    var experiences: [Experience] = []
    
    func createExperience(title: String, coordinate: CLLocationCoordinate2D, imageURL: URL? = nil, audioURL: URL? = nil) {
        let experience = Experience(title: title, coordinate: coordinate, imageURL: imageURL, audioURL: audioURL)
        experiences.append(experience)
    }
}
