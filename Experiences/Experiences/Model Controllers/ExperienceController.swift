//
//  ExperienceController.swift
//  Experiences
//
//  Created by Michael Stoffer on 10/3/19.
//  Copyright © 2019 Michael Stoffer. All rights reserved.
//

import Foundation
import MapKit

class ExperienceController {
    private (set) var experiences: [Experience] = []
    
    func createExperience(withExperienceTitle experienceTitle: String, withImageData imageData: Data, withAudioURL audioURL: URL, withVideoURL videoURL: URL, withCoordinate coordinate: CLLocationCoordinate2D) {
        let experience = Experience(experienceTitle: experienceTitle, imageData: imageData, audioURL: audioURL, videoURL: videoURL, coordinate: coordinate)
        self.experiences.append(experience)
    }
}
