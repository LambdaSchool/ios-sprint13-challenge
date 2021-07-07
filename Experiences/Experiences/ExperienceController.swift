//
//  ExperienceController.swift
//  Experiences
//
//  Created by Daniela Parra on 11/9/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import Foundation
import MapKit

class ExperienceController {
    
    func startExperience(title: String?, coordinate: CLLocationCoordinate2D, image: UIImage?, audioURL: URL?) -> Experience {
        return Experience(title: title, coordinate: coordinate, image: image, audioURL: audioURL, videoURL: nil)
    }
    
    func createExperience(from unfinishedExperience: Experience, videoURL: URL?) -> Experience {
        
        unfinishedExperience.videoURL = videoURL
        
        experiences.append(unfinishedExperience)
        
        return unfinishedExperience
    }
    
    private var experiences: [Experience] = []
}
