//
//  ExperienceController.swift
//  Experiences
//
//  Created by Kobe McKee on 7/11/19.
//  Copyright © 2019 Kobe McKee. All rights reserved.
//

import Foundation
import MapKit

class ExperienceController {
    
    var latestExperience: Experience?
    var experiences: [Experience] = []
    

    func newExperience(title: String, audioURL: URL?, videoURL: URL?, image: URL?, coordinate: CLLocationCoordinate2D) {
        
        let newExperience = Experience(title: title, audio: audioURL, video: videoURL, image: image, coordinate: coordinate)
        
        experiences.append(newExperience)
        latestExperience = newExperience
    }
}
