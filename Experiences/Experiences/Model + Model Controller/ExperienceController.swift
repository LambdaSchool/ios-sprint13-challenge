
//
//  ExperienceController.swift
//  Experiences
//
//  Created by Jason Modisett on 1/18/19.
//  Copyright © 2019 Jason Modisett. All rights reserved.
//

import Foundation
import MapKit

class ExperienceController {
    
    // Start an Experience
    func startExperience(title: String?, coordinate: CLLocationCoordinate2D, image: UIImage?, audioURL: URL?) -> Experience {
        return Experience(title: title, coordinate: coordinate, image: image, audioURL: audioURL, videoURL: nil)
    }
    
    // Add video URL
    func addVideoURL(to experience: Experience, videoURL: URL?) -> Experience {
        experience.videoURL = videoURL
        createExperience(experience)
        
        return experience
    }
    
    // Create & append the new Experience
    private func createExperience(_ experience: Experience) {
        experiences.append(experience)
    }
    
    private var experiences: [Experience] = []
}
