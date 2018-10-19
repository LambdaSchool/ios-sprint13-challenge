//
//  ExperienceController.swift
//  ExperienceTracker
//
//  Created by Jonathan T. Miles on 10/19/18.
//  Copyright © 2018 Jonathan T. Miles. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class ExperienceController {
    
    func createNewExperience(title: String?, audioRecording: URL?, videoRecording: URL?, image: UIImage?, coordinate: CLLocationCoordinate2D) {
        
        let experience = Experience(title: title, audioRecording: audioRecording, videoRecording: videoRecording, image: image, coordinate: coordinate)
        
        experiences.append(experience)
    }
    
    func update(experience: Experience, title: String?, audioRecording: URL?, videoRecording: URL?, image: UIImage?) -> Experience {
        experience.title = title
        experience.audioRecording = audioRecording
        experience.videoRecording = videoRecording
        experience.image = image
        if let index = experiences.firstIndex(of: experience) {
            experiences[index] = experience
        }
        return experience
    }
    
    var experiences: [Experience] = []
    
}
