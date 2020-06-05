//
//  ExperienceController.swift
//  SprintChallengeExperience
//
//  Created by Jerry haaser on 1/17/20.
//  Copyright © 2020 Jerry haaser. All rights reserved.
//

import Foundation
import MapKit

class ExperienceController {
    
    private(set) var experiences: [Experience] = []
    
    func createExperience(title: String, audioURL: URL, videoURL: URL, imageData: Data, coordinate: CLLocationCoordinate2D) {
        let experience = Experience(title: title, audioURL: audioURL, videoURL: videoURL, imageData: imageData, coordinate: coordinate)
        experiences.append(experience)
    }
}
